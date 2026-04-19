with staged as (
    select
        EMPLOYEE_HK,
        LOAD_TIMESTAMP,
        EMPLOYEE_DETAILS_HDF as expected_hdf
    from {{ ref('stg_employee') }}
),
sat as (
    select
        EMPLOYEE_HK,
        LOAD_TIMESTAMP,
        EMPLOYEE_DETAILS_HDF as actual_hdf
    from {{ ref('sat_employee_details') }}
)
select
    s.EMPLOYEE_HK,
    s.LOAD_TIMESTAMP,
    s.expected_hdf,
    t.actual_hdf
from staged s
join sat t
  on s.EMPLOYEE_HK = t.EMPLOYEE_HK
 and s.LOAD_TIMESTAMP = t.LOAD_TIMESTAMP
where s.expected_hdf <> t.actual_hdf
