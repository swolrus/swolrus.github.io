---
layout: page
title: Home
id: home
permalink: /
---

# Welcome! 🌱

This is going to fleshout into a collection of notes over my various different facets of learning and interest. Unfortunately I'm going to utilise a specific obsidian vault to share as we need to be careful these days on what a bot can read. Hopefully some people find this useful/interesting!

Love
DWN

<!-- search bar -->
<div style="display: flex; margin-top: 1rem">
    <strong>Recently updated notes</strong>
    <input class="input is-medium" style="margin-left: auto;" type="text" placeholder="Search notes.." id="search-input" autocomplete="off">
</div>
<ul id="note-list">
  {% assign recent_notes = site.notes | sort: "last_modified_at_timestamp" | reverse %}
  {% for note in recent_notes limit: 5 %}
    <li>
      {{ note.last_modified_at | date: "%Y-%m-%d" }} — <a class="internal-link" href="{{ note.url }}">{{ note.title }}</a>
      <iframe style="height: 0; width: 0;display: 'inline-block';" src="{{ site.url }}{{ note.url }}"></iframe>
    </li>
  {% endfor %}
</ul>
<script>
  const searchInput = document.getElementById("search-input");
  const noteList = document.getElementById("note-list");

  var loaded = false;
  var search = [];
  var timer = null;
  
  window.onload = function() {
    for (var i=0 ; i<noteList.children.length ; i++ ) {
      search[i] = String(noteList.children[i].innerText) + String(noteList.children[i].lastElementChild.contentDocument.children[0].children[1].innerText);
      noteList.children[i].lastElementChild.remove();
    }
    searchInput.addEventListener("input", startInterval);
    loaded = true;
  }

  const startInterval = () => {
    if (!loaded) return;
    stopInterval();
    timer = setInterval(function() {
      doSearch();
    }, 100);
  }

  const stopInterval = () => {
    // To cancel an interval, we pass the timer to clearInterval()
    clearInterval(timer);
  }

  const doSearch = () => {
    var reg = new RegExp(`(^|\\s|,)${searchInput.value}`, 'gi');
    for (var i=0 ; i<noteList.children.length ; i++ ) {
      let li = noteList.children[i];
      if (reg.test(search[i])) {
        li.style["display"] = "list-item";
      } else {
        li.style["display"] = "none";
      }
    }
    clearInterval(timer);
  };
</script>
