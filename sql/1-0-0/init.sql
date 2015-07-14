drop schema if exists membership CASCADE;

create schema membership;
set search_path = membership;

select 'Schema initialized' as result;

create extension if not exists pgcrypto with schema membership;
