---
layout: default
---

<div class="posts">
  {% assign last_year = 9999 %}
  {% for post in site.posts %}
    {% assign this_year = post.date | date: "%Y" %}
    {% if this_year != last_year %}
    <h2>
      {{ this_year }}
    </h2>
    {% endif %}
    <div>
      <span><a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a></span> -

      <span class="date">
        {{ post.date | date: "%e %B" }}
      </span>
    </div>
    {% assign last_year = this_year %}
  {% endfor %}
</div>
