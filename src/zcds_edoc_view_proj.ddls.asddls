@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View ZCDS_EDOC_VIEW'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@UI: { headerInfo: { typeName: 'Electronic Document', typeNamePlural: 'Electronic Documents', title: { type: #STANDARD, value: 'edocflowdescr' } } }

define root view entity ZCDS_EDOC_VIEW_PROJ
  as projection on ZCDS_EDOC_VIEW
{
      @UI.facet: [
          {
              id: 'GeneralInfo',
              purpose: #STANDARD,
              type: #IDENTIFICATION_REFERENCE,
              label: 'General Information',
              position: 10
          },
          {
              id: 'DocumentInfo',
              purpose: #STANDARD,
              type: #FIELDGROUP_REFERENCE,
              label: 'Document Details',
              position: 20,
              targetQualifier: 'DocDetails'
          }
      ]

      @UI.hidden: true
  key edocgroup,

      @UI: {
          lineItem: [ { position: 10, importance: #HIGH } ],
          identification: [ { position: 10 } ],
          selectionField: [ { position: 10 } ]
      }
      @Search.defaultSearchElement: true
  key edocflow,

      @UI: {
          lineItem: [ { position: 20, importance: #HIGH } ], 
          identification: [ { position: 20 } ],
          selectionField: [ { position: 20 } ]
      }
      @Search.defaultSearchElement: true
  key unique_value,

      @UI: {
          lineItem: [ { position: 30, importance: #HIGH },
              { type: #FOR_ACTION, dataAction: 'pdf_display', label: 'Display PDF', position: 1 },
              { type: #FOR_ACTION, dataAction: 'xml_display', label: 'Display XML', position: 2 },
              { type: #FOR_ACTION, dataAction: 'document_post', label: 'Post Document', position: 3 },
              { type: #FOR_ACTION, dataAction: 'uploadXML', label: 'XML Upload', position: 4 },
              { type: #FOR_ACTION, dataAction: 'fileupload', label: 'File Upload-', position: 5 }
           ],
          identification: [ { position: 30 } ],
          fieldGroup: [ { qualifier: 'DocDetails', position: 10 } ]
      }
      @Search.defaultSearchElement: true
      edocflowdescr,

      @UI: {
          lineItem: [ { position: 40 } ],
          fieldGroup: [ { qualifier: 'DocDetails', position: 20 } ]
      }
      descr,

      @UI.hidden: true
      xdata,

      @UI: {
          lineItem: [ { position: 50 } ],
          fieldGroup: [ { qualifier: 'DocDetails', position: 30 } ]
      }
      ernam,

      @UI: {
          lineItem: [ { position: 60 } ],
          fieldGroup: [ { qualifier: 'DocDetails', position: 40 } ]
      }
      erdat,

      @UI: {
          lineItem: [ { position: 70 } ],
          fieldGroup: [ { qualifier: 'DocDetails', position: 50 } ]
      }
      erzet,

      @UI.hidden: true
      tmstp,

      @UI: {
          lineItem: [ { position: 80 } ],
          selectionField: [ { position: 30 } ],
          fieldGroup: [ { qualifier: 'DocDetails', position: 60 } ]
      }
      bukrs,

      @UI: {
          lineItem: [ { position: 90 } ],
          fieldGroup: [ { qualifier: 'DocDetails', position: 70 } ]
      }
      file_name
}
