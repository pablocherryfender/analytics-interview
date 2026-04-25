select
    l.EMPLOYEE_HK
from {{ ref('lnk_employee_department') }} l
left join {{ ref('hub_employee') }} h
  on l.EMPLOYEE_HK = h.EMPLOYEE_HK
where h.EMPLOYEE_HK is null
