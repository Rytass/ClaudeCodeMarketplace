# Quadrats Serializer Complete Rendering Examples

## Basic Article Rendering

Suitable for displaying standard blog articles:

```typescript
import React from 'react';
import { Descendant } from '@quadrats/react';
import { createJsxSerializer } from '@quadrats/react/jsx-serializer';

// Element serializers
import { createJsxSerializeParagraph } from '@quadrats/react/paragraph/jsx-serializer';
import { createJsxSerializeLineBreak } from '@quadrats/react/line-break/jsx-serializer';
import { createJsxSerializeHeading } from '@quadrats/react/heading/jsx-serializer';
import { createJsxSerializeBlockquote } from '@quadrats/react/blockquote/jsx-serializer';
import { createJsxSerializeDivider } from '@quadrats/react/divider/jsx-serializer';
import { createJsxSerializeList } from '@quadrats/react/list/jsx-serializer';
import { createJsxSerializeLink } from '@quadrats/react/link/jsx-serializer';

// Mark serializers
import { createJsxSerializeBold } from '@quadrats/react/bold/jsx-serializer';
import { createJsxSerializeItalic } from '@quadrats/react/italic/jsx-serializer';
import { createJsxSerializeUnderline } from '@quadrats/react/underline/jsx-serializer';
import { createJsxSerializeHighlight } from '@quadrats/react/highlight/jsx-serializer';

// Create serializer
const articleSerializer = createJsxSerializer({
  elements: [
    createJsxSerializeParagraph(),
    createJsxSerializeLineBreak(),
    createJsxSerializeHeading(),
    createJsxSerializeBlockquote(),
    createJsxSerializeDivider(),
    createJsxSerializeList(),
    createJsxSerializeLink(),
  ],
  leafs: [
    createJsxSerializeBold(),
    createJsxSerializeItalic(),
    createJsxSerializeUnderline(),
    createJsxSerializeHighlight(),
  ],
});

// Render component
export function ArticleContent({ content }: { content: Descendant[] }) {
  return (
    <article className="prose prose-lg max-w-none">
      {articleSerializer.serialize(content)}
    </article>
  );
}
```

---

## Media-Rich Content Rendering

Supports image and video embeds:

```typescript
import React from 'react';
import { Descendant } from '@quadrats/react';
import { createJsxSerializer } from '@quadrats/react/jsx-serializer';

// Base elements
import { createJsxSerializeParagraph } from '@quadrats/react/paragraph/jsx-serializer';
import { createJsxSerializeLineBreak } from '@quadrats/react/line-break/jsx-serializer';
import { createJsxSerializeHeading } from '@quadrats/react/heading/jsx-serializer';
import { createJsxSerializeLink } from '@quadrats/react/link/jsx-serializer';

// Media elements
import { createJsxSerializeImage } from '@quadrats/react/image/jsx-serializer';
import { createJsxSerializeEmbed } from '@quadrats/react/embed/jsx-serializer';
import { createJsxSerializeCarousel } from '@quadrats/react/carousel/jsx-serializer';

// Embed strategies and renderers
import { YoutubeEmbedStrategy } from '@quadrats/common/embed/strategies/youtube';
import { VimeoEmbedStrategy } from '@quadrats/common/embed/strategies/vimeo';
import {
  defaultRenderYoutubeEmbedJsxSerializer,
} from '@quadrats/react/embed/renderers/youtube';
import {
  defaultRenderVimeoEmbedJsxSerializer,
} from '@quadrats/react/embed/renderers/vimeo';

// Marks
import { createJsxSerializeBold } from '@quadrats/react/bold/jsx-serializer';
import { createJsxSerializeItalic } from '@quadrats/react/italic/jsx-serializer';

// Create serializer
const mediaSerializer = createJsxSerializer({
  elements: [
    createJsxSerializeParagraph(),
    createJsxSerializeLineBreak(),
    createJsxSerializeHeading(),
    createJsxSerializeLink(),
    createJsxSerializeImage({
      // Custom image hosting resolvers
      hostingResolvers: {
        gcs: (src) => `https://storage.googleapis.com/my-bucket/${src}`,
        cdn: (src) => `https://cdn.example.com/${src}`,
      },
    }),
    createJsxSerializeEmbed({
      strategies: {
        youtube: YoutubeEmbedStrategy,
        vimeo: VimeoEmbedStrategy,
      },
      renderers: {
        youtube: defaultRenderYoutubeEmbedJsxSerializer,
        vimeo: defaultRenderVimeoEmbedJsxSerializer,
      },
    }),
    createJsxSerializeCarousel(),
  ],
  leafs: [
    createJsxSerializeBold(),
    createJsxSerializeItalic(),
  ],
});

export function MediaContent({ content }: { content: Descendant[] }) {
  return (
    <div className="media-content">
      {mediaSerializer.serialize(content)}
    </div>
  );
}
```

---

## Full-Feature Renderer

Supports all Quadrats elements:

```typescript
import React from 'react';
import { Descendant } from '@quadrats/react';
import { createJsxSerializer } from '@quadrats/react/jsx-serializer';

// All element serializers
import { createJsxSerializeParagraph } from '@quadrats/react/paragraph/jsx-serializer';
import { createJsxSerializeLineBreak } from '@quadrats/react/line-break/jsx-serializer';
import { createJsxSerializeHeading } from '@quadrats/react/heading/jsx-serializer';
import { createJsxSerializeBlockquote } from '@quadrats/react/blockquote/jsx-serializer';
import { createJsxSerializeDivider } from '@quadrats/react/divider/jsx-serializer';
import { createJsxSerializeList } from '@quadrats/react/list/jsx-serializer';
import { createJsxSerializeTable } from '@quadrats/react/table/jsx-serializer';
import { createJsxSerializeAccordion } from '@quadrats/react/accordion/jsx-serializer';
import { createJsxSerializeImage } from '@quadrats/react/image/jsx-serializer';
import { createJsxSerializeCarousel } from '@quadrats/react/carousel/jsx-serializer';
import { createJsxSerializeCard } from '@quadrats/react/card/jsx-serializer';
import { createJsxSerializeEmbed } from '@quadrats/react/embed/jsx-serializer';
import { createJsxSerializeLink } from '@quadrats/react/link/jsx-serializer';
import { createJsxSerializeFootnote } from '@quadrats/react/footnote/jsx-serializer';
import { createJsxSerializeReadMore } from '@quadrats/react/read-more/jsx-serializer';

// All mark serializers
import { createJsxSerializeBold } from '@quadrats/react/bold/jsx-serializer';
import { createJsxSerializeItalic } from '@quadrats/react/italic/jsx-serializer';
import { createJsxSerializeUnderline } from '@quadrats/react/underline/jsx-serializer';
import { createJsxSerializeStrikethrough } from '@quadrats/react/strikethrough/jsx-serializer';
import { createJsxSerializeHighlight } from '@quadrats/react/highlight/jsx-serializer';

// Embed strategies and renderers
import { YoutubeEmbedStrategy } from '@quadrats/common/embed/strategies/youtube';
import { VimeoEmbedStrategy } from '@quadrats/common/embed/strategies/vimeo';
import { InstagramEmbedStrategy } from '@quadrats/common/embed/strategies/instagram';
import { FacebookEmbedStrategy } from '@quadrats/common/embed/strategies/facebook';
import { TwitterEmbedStrategy } from '@quadrats/common/embed/strategies/twitter';
import { SpotifyEmbedStrategy } from '@quadrats/common/embed/strategies/spotify';
import { PodcastAppleEmbedStrategy } from '@quadrats/common/embed/strategies/podcast-apple';

import {
  defaultRenderYoutubeEmbedJsxSerializer,
} from '@quadrats/react/embed/renderers/youtube';
import {
  defaultRenderVimeoEmbedJsxSerializer,
} from '@quadrats/react/embed/renderers/vimeo';
import {
  defaultRenderInstagramEmbedJsxSerializer,
} from '@quadrats/react/embed/renderers/instagram';
import {
  defaultRenderFacebookEmbedJsxSerializer,
} from '@quadrats/react/embed/renderers/facebook';
import {
  defaultRenderTwitterEmbedJsxSerializer,
} from '@quadrats/react/embed/renderers/twitter';
import {
  defaultRenderSpotifyEmbedJsxSerializer,
} from '@quadrats/react/embed/renderers/spotify';
import {
  defaultRenderPodcastAppleEmbedJsxSerializer,
} from '@quadrats/react/embed/renderers/podcast-apple';

// Create full serializer
const fullSerializer = createJsxSerializer({
  elements: [
    createJsxSerializeParagraph(),
    createJsxSerializeLineBreak(),
    createJsxSerializeHeading(),
    createJsxSerializeBlockquote(),
    createJsxSerializeDivider(),
    createJsxSerializeList(),
    createJsxSerializeTable(),
    createJsxSerializeAccordion(),
    createJsxSerializeImage(),
    createJsxSerializeCarousel(),
    createJsxSerializeCard(),
    createJsxSerializeEmbed({
      strategies: {
        youtube: YoutubeEmbedStrategy,
        vimeo: VimeoEmbedStrategy,
        instagram: InstagramEmbedStrategy,
        facebook: FacebookEmbedStrategy,
        twitter: TwitterEmbedStrategy,
        spotify: SpotifyEmbedStrategy,
        podcastApple: PodcastAppleEmbedStrategy,
      },
      renderers: {
        youtube: defaultRenderYoutubeEmbedJsxSerializer,
        vimeo: defaultRenderVimeoEmbedJsxSerializer,
        instagram: defaultRenderInstagramEmbedJsxSerializer,
        facebook: defaultRenderFacebookEmbedJsxSerializer,
        twitter: defaultRenderTwitterEmbedJsxSerializer,
        spotify: defaultRenderSpotifyEmbedJsxSerializer,
        podcastApple: defaultRenderPodcastAppleEmbedJsxSerializer,
      },
    }),
    createJsxSerializeLink(),
    createJsxSerializeFootnote(),
    createJsxSerializeReadMore(),
  ],
  leafs: [
    createJsxSerializeBold(),
    createJsxSerializeItalic(),
    createJsxSerializeUnderline(),
    createJsxSerializeStrikethrough(),
    createJsxSerializeHighlight(),
  ],
});

export function FullContent({ content }: { content: Descendant[] }) {
  return (
    <div className="quadrats-content">
      {fullSerializer.serialize(content)}
    </div>
  );
}
```

---

## Custom Rendering Styles

Customize the rendering output for each element:

```typescript
import { createJsxSerializer } from '@quadrats/react/jsx-serializer';
import { createJsxSerializeParagraph } from '@quadrats/react/paragraph/jsx-serializer';
import { createJsxSerializeHeading } from '@quadrats/react/heading/jsx-serializer';
import { createJsxSerializeBlockquote } from '@quadrats/react/blockquote/jsx-serializer';
import { createJsxSerializeImage } from '@quadrats/react/image/jsx-serializer';
import { createJsxSerializeLink } from '@quadrats/react/link/jsx-serializer';
import { createJsxSerializeBold } from '@quadrats/react/bold/jsx-serializer';
import { createJsxSerializeHighlight } from '@quadrats/react/highlight/jsx-serializer';

const customSerializer = createJsxSerializer({
  elements: [
    // Custom paragraph style
    createJsxSerializeParagraph({
      render: ({ children, element }) => (
        <p
          className="my-4 text-gray-800 leading-relaxed"
          style={element.align ? { textAlign: element.align } : undefined}
        >
          {children}
        </p>
      ),
    }),

    // Custom heading style
    createJsxSerializeHeading({
      render: ({ children, element }) => {
        const styles: Record<number, string> = {
          1: 'text-4xl font-bold mb-6 mt-8',
          2: 'text-3xl font-semibold mb-4 mt-6',
          3: 'text-2xl font-medium mb-3 mt-4',
        };
        const Tag = `h${element.level}` as keyof JSX.IntrinsicElements;
        return (
          <Tag className={styles[element.level] || ''}>
            {children}
          </Tag>
        );
      },
    }),

    // Custom blockquote style
    createJsxSerializeBlockquote({
      render: ({ children }) => (
        <blockquote className="border-l-4 border-blue-500 pl-4 my-4 italic text-gray-600">
          {children}
        </blockquote>
      ),
    }),

    // Custom image style
    createJsxSerializeImage({
      figure: {
        render: ({ children, style }) => (
          <figure className="my-6 rounded-lg overflow-hidden shadow-lg" style={style}>
            {children}
          </figure>
        ),
      },
      image: {
        render: ({ src, caption }) => (
          <img
            src={src}
            alt={caption || ''}
            className="w-full object-cover"
            loading="lazy"
          />
        ),
      },
      caption: {
        render: ({ children, isEmpty }) =>
          isEmpty ? null : (
            <figcaption className="text-center text-sm text-gray-500 py-2 bg-gray-50">
              {children}
            </figcaption>
          ),
      },
    }),

    // Custom link style
    createJsxSerializeLink({
      render: ({ children, element }) => (
        <a
          href={element.url}
          target="_blank"
          rel="noopener noreferrer"
          className="text-blue-600 hover:text-blue-800 underline"
        >
          {children}
        </a>
      ),
    }),
  ],
  leafs: [
    // Custom bold style
    createJsxSerializeBold({
      render: ({ children }) => (
        <strong className="font-bold text-gray-900">{children}</strong>
      ),
    }),

    // Custom highlight style (multi-color)
    createJsxSerializeHighlight({
      render: ({ children, leaf }) => {
        const colors: Record<string, string> = {
          default: 'bg-yellow-200',
          yellow: 'bg-yellow-200',
          green: 'bg-green-200',
          blue: 'bg-blue-200',
          pink: 'bg-pink-200',
        };
        const variant = typeof leaf.highlight === 'string'
          ? leaf.highlight
          : 'default';
        return (
          <mark className={`${colors[variant] || colors.default} px-1 rounded`}>
            {children}
          </mark>
        );
      },
    }),
  ],
});
```

---

## SSR / Next.js Integration

Using the serializer in Next.js:

```typescript
// lib/serializer.ts
import { createJsxSerializer } from '@quadrats/react/jsx-serializer';
import { createJsxSerializeParagraph } from '@quadrats/react/paragraph/jsx-serializer';
import { createJsxSerializeHeading } from '@quadrats/react/heading/jsx-serializer';
import { createJsxSerializeBold } from '@quadrats/react/bold/jsx-serializer';
import { createJsxSerializeItalic } from '@quadrats/react/italic/jsx-serializer';

export const contentSerializer = createJsxSerializer({
  elements: [
    createJsxSerializeParagraph(),
    createJsxSerializeHeading(),
  ],
  leafs: [
    createJsxSerializeBold(),
    createJsxSerializeItalic(),
  ],
});

// app/article/[slug]/page.tsx
import { contentSerializer } from '@/lib/serializer';

async function getArticle(slug: string) {
  // Fetch article data from API or database
  const res = await fetch(`https://api.example.com/articles/${slug}`);
  return res.json();
}

export default async function ArticlePage({
  params,
}: {
  params: { slug: string };
}) {
  const article = await getArticle(params.slug);

  return (
    <main className="container mx-auto px-4 py-8">
      <h1 className="text-4xl font-bold mb-8">{article.title}</h1>
      <div className="prose prose-lg">
        {contentSerializer.serialize(article.content)}
      </div>
    </main>
  );
}
```

---

## Using Themes with ConfigsProvider

```typescript
import { ConfigsProvider } from '@quadrats/react/configs';
import { zhTW } from '@quadrats/locales';
import { Descendant } from '@quadrats/react';

function ThemedContent({ content }: { content: Descendant[] }) {
  return (
    <ConfigsProvider theme="light" locale={zhTW}>
      {({ theme: { props: { style, className } } }) => (
        <div className={className} style={style}>
          {contentSerializer.serialize(content)}
        </div>
      )}
    </ConfigsProvider>
  );
}

// Dark mode
function DarkThemedContent({ content }: { content: Descendant[] }) {
  return (
    <ConfigsProvider theme="dark" locale={zhTW}>
      {({ theme: { props: { style, className } } }) => (
        <div className={className} style={style}>
          {contentSerializer.serialize(content)}
        </div>
      )}
    </ConfigsProvider>
  );
}
```

---

## Data Structure Examples

### Basic Text Content

```json
[
  {
    "type": "heading",
    "level": 1,
    "children": [{ "text": "Article Title" }]
  },
  {
    "type": "paragraph",
    "children": [
      { "text": "This is a " },
      { "text": "bold", "bold": true },
      { "text": " and " },
      { "text": "italic", "italic": true },
      { "text": " text." }
    ]
  }
]
```

### Image Content

```json
[
  {
    "type": "image_figure",
    "children": [
      {
        "type": "image",
        "src": "https://example.com/photo.jpg",
        "width": 100,
        "children": [{ "text": "" }]
      },
      {
        "type": "image_caption",
        "children": [{ "text": "Image caption text" }]
      }
    ]
  }
]
```

### YouTube Embed

```json
[
  {
    "type": "embed",
    "provider": "youtube",
    "embedData": {
      "id": "dQw4w9WgXcQ"
    },
    "children": [{ "text": "" }]
  }
]
```

### List Content

```json
[
  {
    "type": "ul",
    "children": [
      {
        "type": "li",
        "children": [{ "text": "Item one" }]
      },
      {
        "type": "li",
        "children": [
          { "text": "Item two (" },
          { "text": "important", "bold": true },
          { "text": ")" }
        ]
      }
    ]
  }
]
```

### Table Content

```json
[
  {
    "type": "table",
    "children": [
      {
        "type": "table_main",
        "children": [
          {
            "type": "table_header",
            "children": [
              {
                "type": "table_row",
                "children": [
                  {
                    "type": "table_cell",
                    "header": true,
                    "children": [{ "text": "Column A" }]
                  },
                  {
                    "type": "table_cell",
                    "header": true,
                    "children": [{ "text": "Column B" }]
                  }
                ]
              }
            ]
          },
          {
            "type": "table_body",
            "children": [
              {
                "type": "table_row",
                "children": [
                  {
                    "type": "table_cell",
                    "children": [{ "text": "Data 1" }]
                  },
                  {
                    "type": "table_cell",
                    "children": [{ "text": "Data 2" }]
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }
]
```
