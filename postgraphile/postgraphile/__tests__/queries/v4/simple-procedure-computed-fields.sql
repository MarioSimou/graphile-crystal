select __person_result__.*
from (
  select
    ids.ordinality - 1 as idx,
    (ids.value->>0)::"text" as "id0",
    (ids.value->>1)::"text" as "id1"
  from json_array_elements($1::json) with ordinality as ids
) as __person_identifiers__,
lateral (
  select
    (select json_agg(_) from (
      select
        __compound_key__."person_id_2"::text as "0",
        __compound_key__."person_id_1"::text as "1"
      from "c"."compound_key" as __compound_key__
      where (
        __person__."id"::"int4" = __compound_key__."person_id_2"
      )
      order by __compound_key__."person_id_1" asc, __compound_key__."person_id_2" asc
    ) _) as "0",
    (select json_agg(_) from (
      select
        __compound_key_2."person_id_2"::text as "0",
        __compound_key_2."person_id_1"::text as "1"
      from "c"."compound_key" as __compound_key_2
      where (
        __person__."id"::"int4" = __compound_key_2."person_id_1"
      )
      order by __compound_key_2."person_id_1" asc, __compound_key_2."person_id_2" asc
    ) _) as "1",
    (select json_agg(_) from (
      select
        (select json_agg(_) from (
          select
            to_char(__post_computed_interval_set__.v, 'YYYY_MM_DD_HH24_MI_SS.US'::text) as "0"
          from "a"."post_computed_interval_set"(__post__) as __post_computed_interval_set__(v)
          limit 1
        ) _) as "0",
        __post__."author_id"::text as "1",
        "a"."post_headline_trimmed"(__post__) as "2",
        __post__."headline" as "3"
      from "a"."post" as __post__
      where
        (
          __post__."headline" = __person_identifiers__."id0"
        ) and (
          __person__."id"::"int4" = __post__."author_id"
        )
      order by __post__."id" asc
    ) _) as "2",
    (select json_agg(_) from (
      select
        (select json_agg(_) from (
          select
            to_char(__post_computed_interval_set_2.v, 'YYYY_MM_DD_HH24_MI_SS.US'::text) as "0"
          from "a"."post_computed_interval_set"(__post_2) as __post_computed_interval_set_2(v)
          limit 1
        ) _) as "0",
        __post_2."author_id"::text as "1",
        "a"."post_headline_trimmed"(__post_2) as "2",
        __post_2."headline" as "3"
      from "a"."post" as __post_2
      where
        (
          __post_2."headline" = __person_identifiers__."id1"
        ) and (
          __person__."id"::"int4" = __post_2."author_id"
        )
      order by __post_2."id" asc
    ) _) as "3",
    (select json_agg(_) from (
      select
        (select json_agg(_) from (
          select
            to_char(__post_computed_interval_set_3.v, 'YYYY_MM_DD_HH24_MI_SS.US'::text) as "0"
          from "a"."post_computed_interval_set"(__post_3) as __post_computed_interval_set_3(v)
          limit 1
        ) _) as "0",
        __post_3."author_id"::text as "1",
        "a"."post_headline_trimmed"(__post_3) as "2",
        __post_3."headline" as "3"
      from "a"."post" as __post_3
      where (
        __person__."id"::"int4" = __post_3."author_id"
      )
      order by __post_3."id" asc
      limit 2
    ) _) as "4",
    (select json_agg(_) from (
      select
        (select json_agg(_) from (
          select
            to_char(__post_computed_interval_set_4.v, 'YYYY_MM_DD_HH24_MI_SS.US'::text) as "0"
          from "a"."post_computed_interval_set"(__post_4) as __post_computed_interval_set_4(v)
          limit 1
        ) _) as "0",
        __post_4."author_id"::text as "1",
        "a"."post_headline_trimmed"(__post_4) as "2",
        __post_4."headline" as "3"
      from "a"."post" as __post_4
      where (
        __person__."id"::"int4" = __post_4."author_id"
      )
      order by __post_4."id" desc
      limit 2
    ) _) as "5",
    __person__."id"::text as "6",
    (select json_agg(_) from (
      select
        (select json_agg(_) from (
          select
            "c"."person_first_name"(__person_friends__) as "0",
            __person_friends__."person_full_name" as "1",
            __person_friends__."id"::text as "2"
          from "c"."person_friends"(__person_friends_2) as __person_friends__
          limit 1
        ) _) as "0",
        "c"."person_first_name"(__person_friends_2) as "1",
        __person_friends_2."person_full_name" as "2",
        __person_friends_2."id"::text as "3"
      from "c"."person_friends"(__person__) as __person_friends_2
    ) _) as "7",
    "c"."person_first_name"(__person__) as "8",
    __person__."person_full_name" as "9",
    __person_identifiers__.idx as "10"
  from "c"."person" as __person__
  order by __person__."id" asc
) as __person_result__;

select __person_result__.*
from (
  select
    ids.ordinality - 1 as idx,
    (ids.value->>0)::"text" as "id0",
    (ids.value->>1)::"text" as "id1"
  from json_array_elements($1::json) with ordinality as ids
) as __person_identifiers__,
lateral (
  select
    (select json_agg(_) from (
      select
        __compound_key__."person_id_2"::text as "0",
        __compound_key__."person_id_1"::text as "1"
      from "c"."compound_key" as __compound_key__
      where (
        __person__."id"::"int4" = __compound_key__."person_id_2"
      )
      order by __compound_key__."person_id_1" asc, __compound_key__."person_id_2" asc
    ) _) as "0",
    (select json_agg(_) from (
      select
        __compound_key_2."person_id_2"::text as "0",
        __compound_key_2."person_id_1"::text as "1"
      from "c"."compound_key" as __compound_key_2
      where (
        __person__."id"::"int4" = __compound_key_2."person_id_1"
      )
      order by __compound_key_2."person_id_1" asc, __compound_key_2."person_id_2" asc
    ) _) as "1",
    (select json_agg(_) from (
      select
        (select json_agg(_) from (
          select
            to_char(__post_computed_interval_set__.v, 'YYYY_MM_DD_HH24_MI_SS.US'::text) as "0"
          from "a"."post_computed_interval_set"(__post__) as __post_computed_interval_set__(v)
          limit 1
        ) _) as "0",
        __post__."author_id"::text as "1",
        "a"."post_headline_trimmed"(__post__) as "2",
        __post__."headline" as "3"
      from "a"."post" as __post__
      where
        (
          __post__."headline" = __person_identifiers__."id0"
        ) and (
          __person__."id"::"int4" = __post__."author_id"
        )
      order by __post__."id" asc
    ) _) as "2",
    (select json_agg(_) from (
      select
        (select json_agg(_) from (
          select
            to_char(__post_computed_interval_set_2.v, 'YYYY_MM_DD_HH24_MI_SS.US'::text) as "0"
          from "a"."post_computed_interval_set"(__post_2) as __post_computed_interval_set_2(v)
          limit 1
        ) _) as "0",
        __post_2."author_id"::text as "1",
        "a"."post_headline_trimmed"(__post_2) as "2",
        __post_2."headline" as "3"
      from "a"."post" as __post_2
      where
        (
          __post_2."headline" = __person_identifiers__."id1"
        ) and (
          __person__."id"::"int4" = __post_2."author_id"
        )
      order by __post_2."id" asc
    ) _) as "3",
    (select json_agg(_) from (
      select
        (select json_agg(_) from (
          select
            to_char(__post_computed_interval_set_3.v, 'YYYY_MM_DD_HH24_MI_SS.US'::text) as "0"
          from "a"."post_computed_interval_set"(__post_3) as __post_computed_interval_set_3(v)
          limit 1
        ) _) as "0",
        __post_3."author_id"::text as "1",
        "a"."post_headline_trimmed"(__post_3) as "2",
        __post_3."headline" as "3"
      from "a"."post" as __post_3
      where (
        __person__."id"::"int4" = __post_3."author_id"
      )
      order by __post_3."id" asc
      limit 2
    ) _) as "4",
    (select json_agg(_) from (
      select
        (select json_agg(_) from (
          select
            to_char(__post_computed_interval_set_4.v, 'YYYY_MM_DD_HH24_MI_SS.US'::text) as "0"
          from "a"."post_computed_interval_set"(__post_4) as __post_computed_interval_set_4(v)
          limit 1
        ) _) as "0",
        __post_4."author_id"::text as "1",
        "a"."post_headline_trimmed"(__post_4) as "2",
        __post_4."headline" as "3"
      from "a"."post" as __post_4
      where (
        __person__."id"::"int4" = __post_4."author_id"
      )
      order by __post_4."id" desc
      limit 2
    ) _) as "5",
    __person__."person_full_name" as "6",
    __person__."id"::text as "7",
    __person_identifiers__.idx as "8"
  from "c"."person" as __person__
  order by __person__."id" asc
) as __person_result__;