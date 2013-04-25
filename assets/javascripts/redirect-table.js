---
# vim:set sts=2 sw=2 tw=0 et:
---
redirect({ {% for p in site.pages %}{% if p.old-url %}
    "{{ p.old-url }}" : "{{ p.url }}",{% endif %}{% endfor %}
    "_" : "_"
});
