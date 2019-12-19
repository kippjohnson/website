---
layout: archive
title: "Publications"
permalink: /publications/
author_profile: true
---

<script type='text/javascript' src='https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js'></script>

<style>
ol {
 color: #476573;
}
ol p {
 color: #696969;
 font-size: 1em;
}
</style>

<i>Click on article title to access the document in PDF.</i>
 
{% if author.googlescholar %}
  You can also find my articles on <u><a href="{{author.googlescholar}}">my Google Scholar profile</a>.</u>
{% endif %}

{% include base_path %}

<ol>
{% for post in site.publications  %}
<li>
<p>{% include archive-single.html %}</p>
</li>
{% endfor %}
</ol>

