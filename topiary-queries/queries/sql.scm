(comment) @append_hardline ; don't accidentally comment stuff that wasnt commented

; INDENT CTEs
(cte (statement) @prepend_indent_start @prepend_hardline)
(cte (_) @append_indent_end .)
; anything after the end of a CTE should have a newline
(
  (cte)
  .
  (_) @prepend_hardline
)
(subquery . (_) @prepend_indent_start @prepend_hardline)
(subquery (_) @append_indent_end .)
(subquery) @append_hardline



(select_expression (
 (term) @append_hardline
 .
 (term)
))

(select_expression . (term) @append_indent_start)
(select_expression (term) @append_indent_end . )
(select_expression (term) @append_hardline . )

; FROM
((relation) @append_space)
(from
   [(relation) (join)] @append_hardline
   .
   [(relation) (join)]
)

; if it's a bunch of joins, indent the predicates, but not the join statements
(from
  (join
    (relation) @append_hardline
    .
     [(keyword_on) (keyword_using)] @prepend_indent_start
	 predicate: (_) @append_indent_end @prepend_indent_start
	) @append_indent_end
)

; if it's more than one relation, indent them all
(from (
   (keyword_from)
   .
   (relation) @append_indent_start
   .
   (relation)*
   .
   (relation) @append_indent_end
   .
	[
    (where)
    (group_by)
    (window_clause)
    (order_by)
    (limit)
	 ]
		)
)
(from) @append_hardline



(relation (object_reference) @append_space)

; enforce use of the "as" keyword
(
 (relation
   (object_reference) @append_delimiter
   .
   (keyword_as)* @do_nothing
   alias: (_)
   (#delimiter! "as ")
  )
)

(term
  ;order matters here, doing @append_delimiter and then @append_space will cause "as\s\s", rather than "\sas\s"
  value: ((_) @append_space @append_delimiter)
  .(keyword_as)* @do_nothing
  alias: (_)
  (#delimiter! "as ")
)

; long/complex terms should get put on their own lines with an indent level
; for all of the clauses that can fall under a from, put a hardline in front, and
; give them their own indented block
; TODO handle index_hint?
(from
   ([
     (where)
     (group_by)
     (window_clause)
     (order_by)
     (limit)
   ] @prepend_hardline
   )
)

(
 [
  (keyword_where)
  ((keyword_group) . (keyword_by))
  ((keyword_order) . (keyword_by))
  (keyword_limit)
  ] @append_indent_start
 . (_ (_) @append_indent_end .)*
)



[
 (keyword_and)
 (keyword_or)
] @prepend_hardline

; keep spaces around operators in binary expressions
(binary_expression
  operator: [
    "<>"
    ">"
    ">="
;    "&"
    "<"
    "<="
    "+"
    "-"
    "*"
    "/"
    "%"
    "^"
    "="
    (op_other)
    (keyword_is)
    (is_not)
    (keyword_like)
    (not_like)
    (similar_to)
    (not_similar_to)
    (distinct_from)
    (not_distinct_from)
  ] @append_space @prepend_space
)

; if the binary expression goes across multiple lines:
;   - put the operators on the left
;   - surround with parenthesis
(binary_expression
  left: (_) @append_hardline
  (#multi_line_scope_only! "binary_expression")
)
; Handle nested/mutliline function calls
; this is a little tricky
; https://github.com/tweag/topiary?tab=readme-ov-file#single_line_scope_only--multi_line_scope_only

; KEYWORDS
[
    (keyword_select)
    (keyword_delete)
    (keyword_insert)
    (keyword_replace)
    (keyword_update)
    (keyword_truncate)
    (keyword_merge)
    (keyword_show)
    (keyword_unload)
    (keyword_into)
    (keyword_overwrite)
    (keyword_values)
    (keyword_value)
    (keyword_matched)
    (keyword_set)
    (keyword_from)
    (keyword_left)
    (keyword_right)
    (keyword_inner)
    (keyword_full)
    (keyword_outer)
    (keyword_cross)
    (keyword_join)
    (keyword_lateral)
    (keyword_natural)
    (keyword_on)
    (keyword_off)
    (keyword_where)
    (keyword_order)
    (keyword_group)
    (keyword_partition)
    (keyword_by)
    (keyword_having)
    (keyword_desc)
    (keyword_asc)
    (keyword_limit)
    (keyword_offset)
    (keyword_primary)
    (keyword_create)
    (keyword_alter)
    (keyword_change)
    (keyword_analyze)
    (keyword_explain)
    (keyword_verbose)
    (keyword_modify)
    (keyword_drop)
    (keyword_add)
    (keyword_table)
    (keyword_tables)
    (keyword_view)
    (keyword_column)
    (keyword_columns)
    (keyword_materialized)
    (keyword_tablespace)
    (keyword_sequence)
    (keyword_increment)
    (keyword_minvalue)
    (keyword_maxvalue)
    (keyword_none)
    (keyword_owned)
    (keyword_start)
    (keyword_restart)
    (keyword_key)
    (keyword_duplicate)
    (keyword_as)
    (keyword_distinct)
    (keyword_constraint)
    (keyword_filter)
    (keyword_cast)
    (keyword_separator)
    (keyword_case)
    (keyword_when)
    (keyword_then)
    (keyword_else)
    (keyword_end)
    (keyword_in)
    (keyword_and)
    (keyword_or)
    (keyword_is)
    (keyword_not)
    (keyword_force)
    (keyword_ignore)
    (keyword_using)
    (keyword_use)
    (keyword_index)
    (keyword_for)
    (keyword_if)
    (keyword_exists)
    (keyword_auto_increment)
    (keyword_generated)
    (keyword_always)
    (keyword_collate)
    (keyword_character)
    (keyword_engine)
    (keyword_default)
    (keyword_cascade)
    (keyword_restrict)
    (keyword_with)
    (keyword_without)
    (keyword_no)
    (keyword_data)
    (keyword_type)
    (keyword_rename)
    (keyword_to)
    (keyword_database)
    (keyword_schema)
    (keyword_owner)
    (keyword_user)
    (keyword_admin)
    (keyword_password)
    (keyword_encrypted)
    (keyword_valid)
    (keyword_until)
    (keyword_connection)
    (keyword_role)
    (keyword_reset)
    (keyword_temp)
    (keyword_temporary)
    (keyword_unlogged)
    (keyword_logged)
    (keyword_cycle)
    (keyword_union)
    (keyword_all)
    (keyword_any)
    (keyword_some)
    (keyword_except)
    (keyword_intersect)
    (keyword_returning)
    (keyword_begin)
    (keyword_commit)
    (keyword_rollback)
    (keyword_transaction)
    (keyword_over)
    (keyword_nulls)
    (keyword_first)
    (keyword_after)
    (keyword_before)
    (keyword_last)
    (keyword_window)
    (keyword_range)
    (keyword_rows)
    (keyword_groups)
    (keyword_between)
    (keyword_unbounded)
    (keyword_preceding)
    (keyword_following)
    (keyword_exclude)
    (keyword_current)
    (keyword_row)
    (keyword_ties)
    (keyword_others)
    (keyword_only)
    (keyword_unique)
    (keyword_foreign)
    (keyword_references)
    (keyword_concurrently)
    (keyword_btree)
    (keyword_hash)
    (keyword_gist)
    (keyword_spgist)
    (keyword_gin)
    (keyword_brin)
    (keyword_like)
    (keyword_similar)
    (keyword_unsigned)
    (keyword_zerofill)
    (keyword_conflict)
    (keyword_do)
    (keyword_nothing)
    (keyword_high_priority)
    (keyword_low_priority)
    (keyword_delayed)
    (keyword_recursive)
    (keyword_cascaded)
    (keyword_local)
    (keyword_current_timestamp)
    (keyword_check)
    (keyword_option)
    (keyword_vacuum)
    (keyword_wait)
    (keyword_nowait)
    (keyword_attribute)
    (keyword_authorization)
    (keyword_action)
    (keyword_extension)
    (keyword_copy)
    (keyword_stdin)
    (keyword_freeze)
    (keyword_escape)
    (keyword_encoding)
    (keyword_force_quote)
    (keyword_quote)
    (keyword_force_null)
    (keyword_force_not_null)
    (keyword_header)
    (keyword_match)
    (keyword_program)
    (keyword_plain)
    (keyword_extended)
    (keyword_main)
    (keyword_storage)
    (keyword_compression)

    (keyword_trigger)
    (keyword_function)
    (keyword_returns)
    (keyword_return)
    (keyword_setof)
    (keyword_atomic)
    (keyword_declare)
    (keyword_language)
    (keyword_immutable)
    (keyword_stable)
    (keyword_volatile)
    (keyword_leakproof)
    (keyword_parallel)
    (keyword_safe)
    (keyword_unsafe)
    (keyword_restricted)
    (keyword_called)
    (keyword_returns)
    (keyword_input)
    (keyword_strict)
    (keyword_cost)
    (keyword_rows)
    (keyword_support)
    (keyword_definer)
    (keyword_invoker)
    (keyword_security)
    (keyword_version)
    (keyword_extension)
    (keyword_out)
    (keyword_inout)
    (keyword_variadic)
    (keyword_ordinality)

    (keyword_session)
    (keyword_isolation)
    (keyword_level)
    (keyword_serializable)
    (keyword_repeatable)
    (keyword_read)
    (keyword_write)
    (keyword_committed)
    (keyword_uncommitted)
    (keyword_deferrable)
    (keyword_names)
    (keyword_zone)
    (keyword_immediate)
    (keyword_deferred)
    (keyword_constraint)
    (keyword_snapshot)
    (keyword_characteristics)
    (keyword_follows)
    (keyword_precedes)
    (keyword_each)
    (keyword_instead)
    (keyword_of)
    (keyword_initially)
    (keyword_old)
    (keyword_new)
    (keyword_referencing)
    (keyword_statement)
    (keyword_execute)
    (keyword_procedure)

    (keyword_external)
    (keyword_stored)
    (keyword_virtual)
    (keyword_cached)
    (keyword_uncached)
    (keyword_replication)
    (keyword_tblproperties)
    (keyword_compute)
    (keyword_stats)
    (keyword_statistics)
    (keyword_optimize)
    (keyword_rewrite)
    (keyword_bin_pack)
    (keyword_incremental)
    (keyword_location)
    (keyword_partitioned)
    (keyword_comment)
    (keyword_sort)
    (keyword_format)
    (keyword_delimited)
    (keyword_delimiter)
    (keyword_fields)
    (keyword_terminated)
    (keyword_escaped)
    (keyword_lines)
    (keyword_cache)
    (keyword_metadata)
    (keyword_noscan)

    (keyword_parquet)
    (keyword_rcfile)
    (keyword_csv)
    (keyword_textfile)
    (keyword_avro)
    (keyword_sequencefile)
    (keyword_orc)
    (keyword_avro)
    (keyword_jsonfile)
] @append_space @prepend_space @lower_case
