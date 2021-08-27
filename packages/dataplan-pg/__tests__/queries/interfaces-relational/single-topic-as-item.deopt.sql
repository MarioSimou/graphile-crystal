select __relational_topics_result__.*
from (
  select
    ids.ordinality - 1 as idx,
    (ids.value->>0)::"int4" as "id0"
  from json_array_elements($1::json) with ordinality as ids
) as __relational_topics_identifiers__,
lateral (
  select
    __relational_items__."type"::text as "0",
    __relational_items__."position"::text as "1",
    __relational_items__."created_at"::text as "2",
    __relational_items__."updated_at"::text as "3",
    __relational_items__."is_explicitly_archived"::text as "4",
    __relational_items__."archived_at"::text as "5",
    __relational_topics__."id"::text as "6",
    __relational_topics__."title"::text as "7",
    __relational_topics_identifiers__.idx as "8"
  from interfaces_and_unions.relational_topics as __relational_topics__
  left outer join interfaces_and_unions.relational_items as __relational_items__
  on (__relational_topics__."id"::"int4" = __relational_items__."id")
  where
    (
      true /* authorization checks */
    ) and (
      __relational_topics__."id" = __relational_topics_identifiers__."id0"
    )
  order by __relational_topics__."id" asc
) as __relational_topics_result__