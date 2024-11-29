@AbapCatalog.sqlViewName: 'ZFILEUPLOAD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'File Upload CDS View'
@OData.publish: true
define view ZI_FILE_UPLOAD as select from ztfile_upload {
    key file_id,
    @EndUserText.label: 'Nome File'
    filename,
    @EndUserText.label: 'Contenuto File'
    filecontent,
    @EndUserText.label: 'Data Creazione'
    created_date,
    @EndUserText.label: 'Ora Creazione'
    created_time,
    @EndUserText.label: 'Utente'
    created_by
}
