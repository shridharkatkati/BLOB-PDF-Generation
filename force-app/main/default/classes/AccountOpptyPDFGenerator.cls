public class AccountOpptyPDFGenerator {
  @AuraEnabled
  public static Attachment generatePDF(String accId) {
    // 1. Define the row template
    String rowTemplate = '<tr><td>{0}</td><td>{1}</td><td>{2}</td></tr>';
    String allRows = '';
    String accName;

    // loop through the data to create rows for each record
    List<Opportunity> opps = [
      SELECT Id, Name, Amount, AccountId, StageName, Account.Name
      FROM Opportunity
      WHERE Amount != NULL AND AccountId = :accId
      ORDER BY createdDate
    ];

    for (Opportunity o : opps) {
      accName = o.Account.Name;
      allRows += String.format(
        rowTemplate,
        new List<Object>{ o.Name, o.Amount, o.StageName }
      );
    }

    // 3. Define the full HTML and inject the rows
    String htmlBody =
      '<!DOCTYPE html><html><body><h2><strong>Opportunity Table</strong></h2><br>' +
      '<table border="1" style="width:100%; border-collapse: collapse;">' +
      '<thead><tr><th><strong>Opportunity Name</strong></th><th><strong>Opportunity Amount</strong></th><th><strong>Opportunity Stage</strong></th></tr></thead>' +
      '<tbody>' +
      allRows +
      '</tbody></table></body></html>';

    // 4. Convert to PDF
    Blob pdfBlob = Blob.toPDF(htmlBody);
    Attachment attachmentPDF = new Attachment();
    attachmentPdf.parentId = accId;
    attachmentPdf.name = accName + ' Opportunities.pdf';
    attachmentPdf.body = pdfBlob;

    insert attachmentPdf;
    return attachmentPdf;
  }
}
