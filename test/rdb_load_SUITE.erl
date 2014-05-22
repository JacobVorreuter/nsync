-module(rdb_load_SUITE).
-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

-compile(export_all).

init_per_suite(Config) ->
    application:load(nsync),
    Config.

all() ->
    [dictionary
     ,easily_compressible_string_key
     ,empty_database
     ,hash_as_ziplist
     ,integer_keys
     ,intset_16
     ,intset_32
     ,intset_64
     ,keys_with_expiry
     ,linkedlist
     ,multiple_databases
     ,parser_filters
     ,rdb_version_5_with_checksum
     ,regular_set
     ,regular_sorted_set
     ,sorted_set_as_ziplist
     ,uncompressible_string_keys
     ,ziplist_that_compresses_easily
     ,ziplist_that_doesnt_compress
     ,ziplist_with_integers
     ,zipmap_that_compresses_easily
     ,zipmap_that_doesnt_compress
     ,zipmap_with_big_values].

dictionary(C) -> 
    {eof,<<>>} = rdb_load(dictionary, C).
easily_compressible_string_key(C) -> 
    {eof,<<>>} = rdb_load(easily_compressible_string_key, C).
empty_database(C) -> 
    {eof,<<>>} = rdb_load(empty_database, C).
hash_as_ziplist(C) -> 
    {eof,<<>>} = rdb_load(hash_as_ziplist, C).
integer_keys(C) -> 
    {eof,<<>>} = rdb_load(integer_keys, C).
intset_16(C) -> 
    {eof,<<>>} = rdb_load(intset_16, C).
intset_32(C) -> 
    {eof,<<>>} = rdb_load(intset_32, C).
intset_64(C) -> 
    {eof,<<>>} = rdb_load(intset_64, C).
keys_with_expiry(C) -> 
    {eof,<<>>} = rdb_load(keys_with_expiry, C).
linkedlist(C) -> 
    {eof,<<>>} = rdb_load(linkedlist, C).
multiple_databases(C) -> 
    {eof,<<>>} = rdb_load(multiple_databases, C).
parser_filters(C) -> 
    {eof,<<>>} = rdb_load(parser_filters, C).
rdb_version_5_with_checksum(C) -> 
    {eof,<<>>} = rdb_load(rdb_version_5_with_checksum, C).
regular_set(C) -> 
    {eof,<<>>} = rdb_load(regular_set, C).
regular_sorted_set(C) -> 
    {eof,<<>>} = rdb_load(regular_sorted_set, C).
sorted_set_as_ziplist(C) -> 
    {eof,<<>>} = rdb_load(sorted_set_as_ziplist, C).
uncompressible_string_keys(C) -> 
    {state,_,_,_} = rdb_load(uncompressible_string_keys, C).
ziplist_that_compresses_easily(C) -> 
    {eof,<<>>} = rdb_load(ziplist_that_compresses_easily, C).
ziplist_that_doesnt_compress(C) -> 
    {eof,<<>>} = rdb_load(ziplist_that_doesnt_compress, C).
ziplist_with_integers(C) -> 
    {eof,<<>>} = rdb_load(ziplist_with_integers, C).
zipmap_that_compresses_easily(C) -> 
    {eof,<<>>} = rdb_load(zipmap_that_compresses_easily, C).
zipmap_that_doesnt_compress(C) -> 
    {eof,<<>>} = rdb_load(zipmap_that_doesnt_compress, C).
zipmap_with_big_values(C) -> 
    {state,_,_,_} = rdb_load(zipmap_with_big_values, C).

rdb_load(TestFile, Config) ->
    FileName = filename:join(?config(data_dir, Config),
                             atom_to_list(TestFile) ++ ".rdb"),
    rdb_load:load_file(FileName,
                       fun (_) -> ok end).
