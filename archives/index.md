---
layout: default
---

<div class="posts">
  {% for post in site.posts %}
    <div>
      <span><a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a></span> -

      <span class="date">
        {{ post.date | date: "%e %B %Y" }}
      </span>
    </div>S
  {% endfor %}
</div>