@EndUserText.label: 'Electronic Document View'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define root view entity ZCDS_EDOC_VIEW
  as select from zedocgroup_db as GroupDB
    inner join   zedoc_flow    as Flow     on GroupDB.edocgroup = Flow.edocgroup
    inner join   zedoc_db      as DocDB    on Flow.edocflow = DocDB.edocflow
    inner join   zoe_edocfile  as DocFile  on DocDB.unique_value = DocFile.edoc_guid
    inner join   zoe_edocument as Document on DocDB.unique_value = Document.edoc_guid
{

      @Search.defaultSearchElement: true
  key GroupDB.edocgroup,
   @Search.defaultSearchElement: true
  key Flow.edocflow,
   @Search.defaultSearchElement: true
  key DocDB.unique_value,
      Flow.edocflowdescr,
      GroupDB.descr,
      DocDB.xdata,
      DocDB.ernam,
      DocDB.erdat,
      DocDB.erzet,
      DocDB.tmstp,
      Document.bukrs,
      DocFile.file_name       
}
where
  DocDB.edocflow = 'EDOC'
