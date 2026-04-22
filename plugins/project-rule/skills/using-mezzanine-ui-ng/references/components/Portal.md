# Portal

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/v2/packages/ng/portal) · Verified 1.0.0-rc.3 (2026-04-21)

Teleports projected content to a global container outside the component tree. Backed by `MznPortalRegistry` which manages two stacking layers (`default` and `alert`) mounted on `document.body`. Used internally by modals, drawers, and other overlay components.

## Import

```ts
import { MznPortal, MznPortalRegistry } from '@mezzanine-ui/ng/portal';
import type { PortalLayer } from '@mezzanine-ui/ng/portal';
```

## Selector

`[mznPortal]` — component applied to a container element.

## Inputs

| Input           | Type                      | Default     | Description                                                   |
| --------------- | ------------------------- | ----------- | ------------------------------------------------------------- |
| `disablePortal` | `boolean`                 | `false`     | When `true`, content renders in-place (no portal)             |
| `layer`         | `PortalLayer`             | `'default'` | Target layer: `'default'` or `'alert'` (higher stacking)      |
| `container`     | `HTMLElement \| undefined` | —          | Custom portal target; overrides `layer` when set              |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## Outputs

None.

## ControlValueAccessor

No.

## Portal Layers

`MznPortalRegistry` creates two containers on `document.body`:

| Layer       | ID                      | Class                  | Use case                      |
| ----------- | ----------------------- | ---------------------- | ----------------------------- |
| `'default'` | `#mzn-portal-container` | `mzn-portal-default`   | Dropdowns, tooltips, overlays |
| `'alert'`   | `#mzn-alert-container`  | `mzn-portal-alert`     | Modals, alerts (higher z)     |

## Usage

```html
<!-- Teleport content to default portal layer -->
<div mznPortal>
  <div class="floating-panel">This renders at document.body level</div>
</div>

<!-- Alert layer (higher z-index) -->
<div mznPortal layer="alert">
  <div class="modal-overlay">Modal content</div>
</div>

<!-- Disable portal (render in-place) -->
<div mznPortal [disablePortal]="true">
  <div>Renders inside current DOM position</div>
</div>

<!-- Custom container target -->
<div mznPortal [container]="customContainer">
  <div>Renders inside customContainer element</div>
</div>
```

```ts
import { MznPortal, MznPortalRegistry } from '@mezzanine-ui/ng/portal';

// Programmatically access a portal container element
private readonly registry = inject(MznPortalRegistry);

getDefaultContainer(): HTMLElement {
  return this.registry.getContainer('default');
}
```

## Notes

- `MznPortalRegistry` is `providedIn: 'root'` and creates containers lazily on first access — no bootstrap configuration required.
- Content is rendered using an `EmbeddedViewRef` created from an `ng-template`. The Angular view hierarchy is preserved (change detection, DI, event binding all work normally) even though the DOM is detached.
- When `disablePortal` is `true`, content renders directly inside the host — this is useful for testing or for embedding an overlay within a scrollable ancestor.
- The `container` input takes precedence over `layer` when both are set.
