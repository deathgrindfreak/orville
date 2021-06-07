{-|
Module    : Database.Orville.PostgreSQL.Expr.ColumnDefinition
Copyright : Flipstone Technology Partners 2016-2021
License   : MIT
-}

module Database.Orville.PostgreSQL.Internal.Expr.ColumnDefinition
  ( ColumnDefinition
  , columnDefinition
  , columnDefinitionToSql
  , DataType
  , timestampWithZone
  , date
  , tsvector
  , varchar
  , char
  , text
  , boolean
  , doublePrecision
  , bigSerial
  , bigInt
  , serial
  , int
  ) where

import           Database.Orville.PostgreSQL.Internal.Expr.Name (ColumnName,
                                                                 columnNameToSql)
import qualified Database.Orville.PostgreSQL.Internal.RawSql as RawSql

newtype ColumnDefinition =
  ColumnDefinition RawSql.RawSql

columnDefinitionToSql :: ColumnDefinition -> RawSql.RawSql
columnDefinitionToSql (ColumnDefinition sql) = sql

columnDefinition :: ColumnName -> DataType -> ColumnDefinition
columnDefinition columnName dataType =
  ColumnDefinition $
    columnNameToSql columnName
    <> RawSql.fromString " "
    <> dataTypeToSql dataType

newtype DataType =
  DataType RawSql.RawSql

dataTypeToSql :: DataType -> RawSql.RawSql
dataTypeToSql (DataType sql) = sql

timestampWithZone :: DataType
timestampWithZone =
  DataType (RawSql.fromString "TIMESTAMP with time zone")

date :: DataType
date =
  DataType (RawSql.fromString "DATE")

tsvector :: DataType
tsvector =
  DataType (RawSql.fromString "TSVECTOR")

varchar :: Int -> DataType
varchar len =
  -- postgresql won't let us pass the field length as a parameter.
  -- when we try we get an error like such error:
  --  ERROR:  syntax error at or near "$1" at character 48
  --  STATEMENT:  CREATE TABLE field_definition_test(foo VARCHAR($1))
  DataType $
    RawSql.fromString "VARCHAR("
    <> RawSql.fromString (show len)
    <> RawSql.fromString ")"

char :: Int -> DataType
char len =
  -- postgresql won't let us pass the field length as a parameter.
  -- when we try we get an error like such error:
  --  ERROR:  syntax error at or near "$1" at character 48
  --  STATEMENT:  CREATE TABLE field_definition_test(foo CHAR($1))
  DataType $
    RawSql.fromString "CHAR("
    <> RawSql.fromString (show len)
    <> RawSql.fromString ")"

text :: DataType
text =
  DataType (RawSql.fromString "TEXT")

boolean :: DataType
boolean =
  DataType (RawSql.fromString "BOOLEAN")

doublePrecision :: DataType
doublePrecision =
  DataType (RawSql.fromString "DOUBLE PRECISION")

bigSerial :: DataType
bigSerial =
  DataType (RawSql.fromString "BIGSERIAL")

bigInt :: DataType
bigInt =
  DataType (RawSql.fromString "BIGINT")

serial :: DataType
serial =
  DataType (RawSql.fromString "SERIAL")

int :: DataType
int =
  DataType (RawSql.fromString "INT")
