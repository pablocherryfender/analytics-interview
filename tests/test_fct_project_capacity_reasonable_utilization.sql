select
    project_id,
    utilization_rate
from {{ ref('fct_project_capacity') }}
where utilization_rate > 5
