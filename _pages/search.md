---
layout: page
title: Search
permalink: /search
---

<!-- search bar -->
<div style="display: flex; margin-top: 1rem">
    <strong>ALL NOTES</strong>
    <input class="input is-medium" style="margin-left: auto;" type="text" placeholder="Search notes.." id="search-input" autocomplete="off">
</div>
<ul id="note-list">
  {% assign recent_notes = site.notes | sort: "last_modified_at_timestamp" | reverse %}
  {% for note in recent_notes %}
    <li>
      {{ note.last_modified_at | date: "%Y-%m-%d" }} — <a class="internal-link" href="{{ note.url }}">
      {% if note.index == true %}
        {{ note.title }}
      {% else %}
      {{ note.relative_path | remove: "_notes" }}
      {% endif %}
    </a>
      <div style="display: 'hidden'">{{note.content}}</div>
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
      search[i] = String(noteList.children[i].innerText) + String(noteList.children[i].lastElementChild.innerText);
      noteList.children[i].lastElementChild.remove();
    }
    searchInput.addEventListener("input", startInterval);
    loaded = true;
  }

  const startInterval = () => {
    if (!loaded) return;
    if (timer !== null) {
      clearInterval(timer);
      timer = null;
    }
    timer = setInterval(function() {
      doSearch();
    }, 1000);
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
    timer = null;
  };
</script>
