@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@UI: { headerInfo: { typeName: 'Electronic Document', typeNamePlural: 'Electronic Documents', title: { type: #STANDARD, value: 'edocflowdescr' } } }

define root view entity ZC_UPLOAD
  as projection on ZI_UPLOAD
{
  key UploadId,

      @UI: {
              lineItem: [ { position: 30, importance: #HIGH },
                  { type: #FOR_ACTION, dataAction: 'pdf_display', label: 'Display PDF', position: 1 }
               ],
              identification: [ { position: 30 } ],
              fieldGroup: [ { qualifier: 'DocDetails', position: 10 } ]
          }
      @Search.defaultSearchElement: true
      Filename,
      Mimetype,
      XData,
      CreatedBy,
      CreatedAt,
      ChangedBy,
      ChangedAt
}
