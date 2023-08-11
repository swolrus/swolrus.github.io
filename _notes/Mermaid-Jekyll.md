---
title: Mermaid Integration With Jekyll!
mermaid: true
---

This is just a test of if mermaid works via a conditional include.

## How its done

First this page has this YAML frontmatter:

```yaml
---
title: Mermaid Testing!
mermaid: true
---
```

Then in 

FILE: 'project/_includes/mermaid.html'

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

And in your layout for your notes:

```html
<html>
  <head>
  </head>
  <body>
  ...
  ...
    {% if page.mermaid == 'true' %}
      {% include mermaid.html %}
    {% endif %}
  </body>
</html>
```

lets see if it works ;)

```mermaid
gantt
       dateFormat  YYYY-MM-DD
       title Adding GANTT diagram functionality to mermaid

       section A section
       Completed task            :done,    des1, 2018-01-06,2018-01-08
       Active task               :active,  des2, 2018-01-09, 3d
       Future task               :         des3, after des2, 5d
       Future task2              :         des4, after des3, 5d

       section Critical tasks
       Completed task in the critical line :crit, done, 2018-01-06,24h
       Implement parser and jison          :crit, done, after des1, 2d
       Create tests for parser             :crit, active, 3d
       Future task in critical line        :crit, 5d
       Create tests for renderer           :2d
       Add to mermaid                      :1d

       section Documentation
       Describe gantt syntax               :active, a1, after des1, 3d
       Add gantt diagram to demo page      :after a1  , 20h
       Add another diagram to demo page    :doc1, after a1  , 48h

       section Last section
       Describe gantt syntax               :after doc1, 3d
       Add gantt diagram to demo page      :20h
       Add another diagram to demo page    :48h
```
