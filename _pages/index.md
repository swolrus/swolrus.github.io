---
layout: page
title: Home
id: home
permalink: /
---

# Welcome! 🌱

This is going to fleshout into a collection of notes over my various different facets of learning and interest. Unfortunatly I'm going to utilise a specific obsidian vault to share as we need to be careful these days on what a bot can read. Hopefully some people find this useful/interesting!

Love
DWN

<strong>Recently updated notes</strong>

<ul>
  {% assign recent_notes = site.notes | sort: "last_modified_at_timestamp" | reverse %}
  {% for note in recent_notes limit: 5 %}
    <li>
      {{ note.last_modified_at | date: "%Y-%m-%d" }} — <a class="internal-link" href="{{ note.url }}">{{ note.title }}</a>
    </li>
  {% endfor %}
</ul>
