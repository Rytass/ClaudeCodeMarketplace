#!/usr/bin/env python3
"""
Architecture Inspector MCP Server

MCP server providing project architecture inspection tools.
Communicates via JSON-RPC 2.0 over stdio, supporting the following tools:
- scan-entities: Scan entity files for compliance
- scan-modules: Scan module files for compliance
- check-scaffolding-status: Check module scaffolding progress
- resolve-symbol-map: Resolve the Symbol mapping in ModelsModule
"""

import json
import re
import sys
from pathlib import Path
from typing import Optional

EXCLUDE_DIRS: frozenset[str] = frozenset({
    'node_modules', 'dist', 'generated', '.git', '.next',
})

SERVER_INFO: dict[str, str] = {
    "name": "architecture-inspector",
    "version": "1.0.0",
}

PROTOCOL_VERSION = "2024-11-05"

NESTJS_STEPS: tuple[str, ...] = (
    "entity",
    "symbol-registration",
    "enum",
    "dto",
    "data-service",
    "dataloader",
    "data-module",
    "queries",
    "mutations",
    "resolver",
    "module",
)

NEXTJS_STEPS: tuple[str, ...] = (
    "fragment",
    "query",
    "mutation",
    "codegen",
    "page",
    "styles",
    "table",
    "form-modal",
    "wiring",
)

TOOL_SCHEMAS: list[dict[str, object]] = [
    {
        "name": "scan-entities",
        "description": "Scan entity files in the project, checking for @Entity, @ObjectType decorators and Symbol exports",
        "inputSchema": {
            "type": "object",
            "properties": {
                "root": {
                    "type": "string",
                    "description": "Root directory path to scan for entity files",
                },
            },
            "required": ["root"],
        },
    },
    {
        "name": "scan-modules",
        "description": "Scan module files in the project, checking for corresponding DataModule",
        "inputSchema": {
            "type": "object",
            "properties": {
                "root": {
                    "type": "string",
                    "description": "Root directory path to scan for module files",
                },
            },
            "required": ["root"],
        },
    },
    {
        "name": "check-scaffolding-status",
        "description": "Check scaffolding progress for a given module (NestJS or Next.js)",
        "inputSchema": {
            "type": "object",
            "properties": {
                "root": {
                    "type": "string",
                    "description": "Root directory path of the project",
                },
                "moduleName": {
                    "type": "string",
                    "description": "Name of the module to check (kebab-case)",
                },
                "type": {
                    "type": "string",
                    "description": "Project type: nestjs or nextjs",
                    "enum": ["nestjs", "nextjs"],
                },
            },
            "required": ["root", "moduleName", "type"],
        },
    },
    {
        "name": "resolve-symbol-map",
        "description": "Resolve the Symbol-to-Entity mapping in models.module.ts",
        "inputSchema": {
            "type": "object",
            "properties": {
                "modelsModulePath": {
                    "type": "string",
                    "description": "Absolute path to models.module.ts file",
                },
            },
            "required": ["modelsModulePath"],
        },
    },
]


def _should_exclude(path: Path) -> bool:
    """Check whether the path should be excluded."""
    return bool(EXCLUDE_DIRS & set(path.parts))


def _read_message() -> Optional[dict[str, object]]:
    """Read a JSON-RPC message from stdin (Content-Length header framing)."""
    headers: dict[str, str] = {}

    while True:
        line = sys.stdin.buffer.readline()

        if not line:
            return None

        line_str = line.decode("utf-8").rstrip("\r\n")

        if line_str == "":
            break

        if ":" in line_str:
            key, value = line_str.split(":", 1)
            headers[key.strip()] = value.strip()

    content_length_str = headers.get("Content-Length")

    if content_length_str is None:
        return None

    content_length = int(content_length_str)
    body = sys.stdin.buffer.read(content_length)

    return json.loads(body.decode("utf-8"))


def _write_message(message: dict[str, object]) -> None:
    """Write a JSON-RPC message to stdout (Content-Length header framing)."""
    body = json.dumps(message).encode("utf-8")
    header = f"Content-Length: {len(body)}\r\n\r\n".encode("utf-8")
    sys.stdout.buffer.write(header + body)
    sys.stdout.buffer.flush()


def _make_response(request_id: object, result: object) -> dict[str, object]:
    """Build a JSON-RPC success response."""
    return {
        "jsonrpc": "2.0",
        "id": request_id,
        "result": result,
    }


def _make_error(request_id: object, code: int, message: str) -> dict[str, object]:
    """Build a JSON-RPC error response."""
    return {
        "jsonrpc": "2.0",
        "id": request_id,
        "error": {
            "code": code,
            "message": message,
        },
    }


def _make_tool_result(content: object) -> dict[str, object]:
    """Build an MCP tool result."""
    return {
        "content": [
            {
                "type": "text",
                "text": json.dumps(content, indent=2, ensure_ascii=False),
            },
        ],
    }


def _make_tool_error(message: str) -> dict[str, object]:
    """Build an MCP tool error result."""
    return {
        "content": [
            {
                "type": "text",
                "text": json.dumps({"error": message}, ensure_ascii=False),
            },
        ],
        "isError": True,
    }


# ── Tool Handlers ──────────────────────────────────────────────────────────


def handle_scan_entities(arguments: dict[str, str]) -> dict[str, object]:
    """Scan entity files for compliance."""
    root_str = arguments.get("root")

    if not root_str:
        return _make_tool_error("Missing required argument: root")

    root = Path(root_str)

    if not root.is_dir():
        return _make_tool_error(f"Directory not found: {root_str}")

    results: list[dict[str, object]] = []

    for entity_path in sorted(root.rglob("*.entity.ts")):
        if _should_exclude(entity_path.relative_to(root)):
            continue

        content = entity_path.read_text(encoding="utf-8", errors="replace")

        has_entity = bool(re.search(r"@Entity", content))
        has_object_type = bool(re.search(r"@ObjectType", content))
        has_symbol = bool(re.search(r"export\s+const\s+\w+\s*=\s*Symbol\(", content))

        results.append({
            "path": str(entity_path.relative_to(root)),
            "hasEntity": has_entity,
            "hasObjectType": has_object_type,
            "hasSymbol": has_symbol,
            "isCompliant": has_entity and has_object_type and has_symbol,
        })

    return _make_tool_result(results)


def handle_scan_modules(arguments: dict[str, str]) -> dict[str, object]:
    """Scan module files for compliance."""
    root_str = arguments.get("root")

    if not root_str:
        return _make_tool_error("Missing required argument: root")

    root = Path(root_str)

    if not root.is_dir():
        return _make_tool_error(f"Directory not found: {root_str}")

    results: list[dict[str, object]] = []

    for module_path in sorted(root.rglob("*.module.ts")):
        relative = module_path.relative_to(root)

        if _should_exclude(relative):
            continue

        name = module_path.stem  # e.g. "supplier.module"

        # Exclude data modules, app module, and models module
        if (
            name.endswith("-data.module")
            or name == "app.module"
            or name == "models.module"
        ):
            continue

        # Check whether a corresponding data module exists in the same directory
        base_name = name.replace(".module", "")
        data_module = module_path.parent / f"{base_name}-data.module.ts"
        has_data_module = data_module.exists()

        results.append({
            "modulePath": str(relative),
            "hasDataModule": has_data_module,
            "isCompliant": has_data_module,
        })

    return _make_tool_result(results)


def _check_nestjs_scaffolding(
    root: Path,
    module_name: str,
) -> dict[str, object]:
    """Check NestJS module scaffolding progress."""
    # Collect all files matching the module name
    matching_files: list[Path] = []

    for file_path in root.rglob(f"**/{module_name}*"):
        if _should_exclude(file_path.relative_to(root)):
            continue
        matching_files.append(file_path)

    file_names = [f.name for f in matching_files]
    file_suffixes: set[str] = set()

    for name in file_names:
        # Extract full compound suffix, e.g. "supplier.entity.ts" → ".entity.ts"
        parts = name.split(".", 1)
        if len(parts) > 1:
            file_suffixes.add("." + parts[1])

    done: list[str] = []
    missing: list[str] = []

    # entity
    if any(n.endswith(".entity.ts") for n in file_names):
        done.append("entity")
    else:
        missing.append("entity")

    # symbol-registration: check whether entity files contain Symbol exports
    entity_files = [f for f in matching_files if f.name.endswith(".entity.ts")]
    has_symbol = False

    for ef in entity_files:
        content = ef.read_text(encoding="utf-8", errors="replace")
        if re.search(r"export\s+const\s+\w+\s*=\s*Symbol\(", content):
            has_symbol = True
            break

    if has_symbol:
        done.append("symbol-registration")
    else:
        missing.append("symbol-registration")

    # enum
    if any(n.endswith(".enum.ts") for n in file_names):
        done.append("enum")
    else:
        missing.append("enum")

    # dto
    if any(
        n.endswith(".dto.ts") or n.endswith(".input.ts") or n.endswith(".args.ts")
        for n in file_names
    ):
        done.append("dto")
    else:
        missing.append("dto")

    # data-service
    if any(n.endswith("-data.service.ts") for n in file_names):
        done.append("data-service")
    else:
        missing.append("data-service")

    # dataloader
    if any(n.endswith(".dataloader.ts") for n in file_names):
        done.append("dataloader")
    else:
        missing.append("dataloader")

    # data-module
    if any(n.endswith("-data.module.ts") for n in file_names):
        done.append("data-module")
    else:
        missing.append("data-module")

    # queries
    if any(n.endswith(".queries.ts") for n in file_names):
        done.append("queries")
    else:
        missing.append("queries")

    # mutations
    if any(n.endswith(".mutations.ts") for n in file_names):
        done.append("mutations")
    else:
        missing.append("mutations")

    # resolver
    if any(n.endswith(".resolver.ts") for n in file_names):
        done.append("resolver")
    else:
        missing.append("resolver")

    # module (excluding data modules)
    has_module = any(
        n.endswith(".module.ts") and not n.endswith("-data.module.ts")
        for n in file_names
    )

    if has_module:
        done.append("module")
    else:
        missing.append("module")

    total = len(NESTJS_STEPS)
    completion_pct = round(len(done) / total * 100) if total > 0 else 0

    return {
        "done": done,
        "missing": missing,
        "completionPct": completion_pct,
    }


def _check_nextjs_scaffolding(
    root: Path,
    module_name: str,
) -> dict[str, object]:
    """Check Next.js module scaffolding progress."""
    done: list[str] = []
    missing: list[str] = []

    # Collect all files matching the module name
    matching_files: list[Path] = []

    for file_path in root.rglob(f"**/{module_name}*"):
        if _should_exclude(file_path.relative_to(root)):
            continue
        matching_files.append(file_path)

    # Also collect all potentially related files (e.g. page.tsx, generated/graphql.ts)
    all_files: list[Path] = []

    for file_path in root.rglob("*"):
        if _should_exclude(file_path.relative_to(root)):
            continue
        all_files.append(file_path)

    file_names = [f.name for f in matching_files]

    # fragment
    if any(n.endswith(".fragment.graphql") for n in file_names):
        done.append("fragment")
    else:
        missing.append("fragment")

    # query
    if any(n.endswith(".query.graphql") for n in file_names):
        done.append("query")
    else:
        missing.append("query")

    # mutation
    if any(n.endswith(".mutation.graphql") for n in file_names):
        done.append("mutation")
    else:
        missing.append("mutation")

    # codegen: check whether generated/graphql.ts exists
    has_codegen = any(
        str(f.relative_to(root)).replace("\\", "/").endswith("generated/graphql.ts")
        for f in all_files
    )

    if has_codegen:
        done.append("codegen")
    else:
        missing.append("codegen")

    # page: find page.tsx under directories related to the module name
    has_page = False

    for f in all_files:
        if f.name == "page.tsx" and module_name in str(f.relative_to(root)):
            has_page = True
            break

    if has_page:
        done.append("page")
    else:
        missing.append("page")

    # styles
    if any(n.endswith(".module.scss") for n in file_names):
        done.append("styles")
    else:
        missing.append("styles")

    # table
    has_table = any(
        "table" in n.lower()
        for n in file_names
        if n.endswith(".tsx") or n.endswith(".ts")
    )

    if has_table:
        done.append("table")
    else:
        missing.append("table")

    # form-modal
    has_form_modal = any(
        "formmodal" in n.lower() or "form-modal" in n.lower()
        for n in file_names
        if n.endswith(".tsx") or n.endswith(".ts")
    )

    if has_form_modal:
        done.append("form-modal")
    else:
        missing.append("form-modal")

    # wiring: check whether page.tsx contains mutation hooks
    has_wiring = False

    for f in all_files:
        if (
            f.name == "page.tsx"
            and module_name in str(f.relative_to(root))
        ):
            content = f.read_text(encoding="utf-8", errors="replace")
            if re.search(r"use(Create|Update|Delete)", content):
                has_wiring = True
                break

    if has_wiring:
        done.append("wiring")
    else:
        missing.append("wiring")

    total = len(NEXTJS_STEPS)
    completion_pct = round(len(done) / total * 100) if total > 0 else 0

    return {
        "done": done,
        "missing": missing,
        "completionPct": completion_pct,
    }


def handle_check_scaffolding_status(
    arguments: dict[str, str],
) -> dict[str, object]:
    """Check module scaffolding progress."""
    root_str = arguments.get("root")
    module_name = arguments.get("moduleName")
    project_type = arguments.get("type")

    if not root_str:
        return _make_tool_error("Missing required argument: root")

    if not module_name:
        return _make_tool_error("Missing required argument: moduleName")

    if project_type not in ("nestjs", "nextjs"):
        return _make_tool_error("Argument 'type' must be 'nestjs' or 'nextjs'")

    root = Path(root_str)

    if not root.is_dir():
        return _make_tool_error(f"Directory not found: {root_str}")

    if project_type == "nestjs":
        result = _check_nestjs_scaffolding(root, module_name)
    else:
        result = _check_nextjs_scaffolding(root, module_name)

    return _make_tool_result(result)


def handle_resolve_symbol_map(arguments: dict[str, str]) -> dict[str, object]:
    """Resolve the Symbol mapping in models.module.ts."""
    models_path_str = arguments.get("modelsModulePath")

    if not models_path_str:
        return _make_tool_error("Missing required argument: modelsModulePath")

    models_path = Path(models_path_str)

    if not models_path.is_file():
        return _make_tool_error(f"File not found: {models_path_str}")

    content = models_path.read_text(encoding="utf-8", errors="replace")

    # Parse import statements: import { Xxx } from './path'
    import_map: dict[str, str] = {}

    for match in re.finditer(
        r"import\s*\{([^}]+)\}\s*from\s*['\"]([^'\"]+)['\"]",
        content,
    ):
        names_str = match.group(1)
        import_path = match.group(2)

        for name in names_str.split(","):
            clean_name = name.strip()
            if clean_name:
                import_map[clean_name] = import_path

    # Parse [SymbolName, EntityClass] tuples in the models array
    results: list[dict[str, str]] = []

    for match in re.finditer(
        r"\[\s*(\w+)\s*,\s*(\w+)\s*\]",
        content,
    ):
        symbol_name = match.group(1)
        entity_class = match.group(2)

        result: dict[str, str] = {
            "symbol": symbol_name,
            "entityClass": entity_class,
            "importPath": import_map.get(entity_class, "unknown"),
        }

        results.append(result)

    return _make_tool_result(results)


# ── Tool Dispatcher ────────────────────────────────────────────────────────

TOOL_HANDLERS: dict[str, object] = {
    "scan-entities": handle_scan_entities,
    "scan-modules": handle_scan_modules,
    "check-scaffolding-status": handle_check_scaffolding_status,
    "resolve-symbol-map": handle_resolve_symbol_map,
}


def _handle_request(message: dict[str, object]) -> Optional[dict[str, object]]:
    """Handle a JSON-RPC request and return a response."""
    method = message.get("method", "")
    request_id = message.get("id")
    params = message.get("params", {})

    # Notification messages (no id) require no response
    if request_id is None:
        return None

    if method == "ping":
        return _make_response(request_id, {})

    if method == "initialize":
        return _make_response(request_id, {
            "protocolVersion": PROTOCOL_VERSION,
            "capabilities": {"tools": {}},
            "serverInfo": SERVER_INFO,
        })

    if method == "tools/list":
        return _make_response(request_id, {"tools": TOOL_SCHEMAS})

    if method == "tools/call":
        tool_name = params.get("name", "") if isinstance(params, dict) else ""
        arguments = params.get("arguments", {}) if isinstance(params, dict) else {}

        handler = TOOL_HANDLERS.get(tool_name)

        if handler is None:
            return _make_error(
                request_id,
                -32601,
                f"Unknown tool: {tool_name}",
            )

        try:
            result = handler(arguments)
            return _make_response(request_id, result)
        except Exception as exc:
            return _make_response(request_id, _make_tool_error(str(exc)))

    return _make_error(request_id, -32601, f"Method not found: {method}")


def main() -> None:
    """MCP server main loop."""
    while True:
        message = _read_message()

        if message is None:
            break

        response = _handle_request(message)

        if response is not None:
            _write_message(response)


if __name__ == "__main__":
    main()
