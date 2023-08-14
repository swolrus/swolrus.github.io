# DWN's DIGITAL
> A customisation of the digital gardan jekyll template by maximevaillancourt. Includes better code highlighting and line numbers as well as better flow of text elements.

This project is built to serve a selection of my obsidian notes and uses a GitHub action to automatically deploy to GitHub pages.

## Features

### D3.Force

> See:
>   - `./_includes/notes_graph.html`
>   - `./_layouts/note.html`
>   - `./_pages/graph.md`

The map now uses a simulation for the nodes meaning that they are draggable. Additionally the wrapper uses a unique tag as not to be modified by mermaid and katex maths.

### Katex Maths

> See:
>   - `./assets/css/vendor/*`
>   - `./_includes/head.html` (Line 15)

If a page has `latex: true` in the frontmatter we use katex for kramdown to preprocess the file. This requires gems "kramdown-math-katex" and "execjs" to preprocess the file see `./_config.yml` line 39. A conditional include of katex fonts in `./_includes/head.html`
is the final component.

### Mermaid Charts

> Added mermaid chart rendering

The folowing file is all that is required to generate mermaid charts for the site. What we are doing is hacking kramdowns syntax highlighter to locate the code blocks indicated as mermaid (kramdown will give them the class `langauge-mermaid`).

By selecting all elements with this class and changing it to be the class `.mermaid` when we import the mermaid module it will autmatically process them.

`./_includes/mermaid.html`

```html
<script type="text/javascript">
  let mermaidNodes = document.querySelectorAll('code.language-mermaid');
  for (let mermaidNode of mermaidNodes) {
    mermaidNode.classList = ['mermaid'];
  }
</script>
<script type="module">
  import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs";
</script>
```

### Search

> See the script in
>   - `./_pages/home.html`

This script allows for the quick search through all notes including their content. It utelises a hidden element including the note and some regex to conditionally hide or show elements. It also manages the search function via an interval to interrupt and ensure that only one search is running even while the search string is changing.

## Exerpt From Base Repo

> ## Digital garden Jekyll template
> Use this template repository to get started with your own digital garden.
> **I wrote a tutorial explaining how to set it up: [Setting up your own digital garden with Jekyll](https://maximevaillancourt.com/blog/setting-up-your-own-digital-garden-with-jekyll)**
> Preview the template here: https://digital-garden-jekyll-template.netlify.app/
> - Based on Jekyll, a static website generator
> - Supports Roam-style double bracket link syntax to other notes
> - Creates backlinks to other notes automatically
> - Features link previews on hover
> - Includes graph visualization of the notes and their links
> - Features a simple and responsive design
> - Supports Markdown or HTML notes
> ### License
> Source code is available under the [MIT license](LICENSE.md).
