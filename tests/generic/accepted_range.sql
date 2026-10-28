{#- Same contract as dbt_utils.accepted_range (nulls are ignored), so it can be swapped for the package version later. -#}
{% test accepted_range(model, column_name, min_value=none, max_value=none, inclusive=true) %}

select *
from {{ model }}
where
    1 = 2
    {%- if min_value is not none %}
    or not {{ column_name }} {{ '>=' if inclusive else '>' }} {{ min_value }}
    {%- endif %}
    {%- if max_value is not none %}
    or not {{ column_name }} {{ '<=' if inclusive else '<' }} {{ max_value }}
    {%- endif %}

{% endtest %}
