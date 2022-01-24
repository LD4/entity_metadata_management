{% for editor in include.editors %}
  - **[{{ editor.name }}]({{ editor.orcid }})**, {{ editor.institution }}
{% endfor %}
