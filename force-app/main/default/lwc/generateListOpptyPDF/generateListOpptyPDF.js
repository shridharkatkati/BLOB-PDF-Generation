import { LightningElement, api } from "lwc";
import generatePDF from "@salesforce/apex/AccountOpptyPDFGenerator.generatePDF";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class GenerateListOpptyPDF extends LightningElement {
  @api recordId;
  // {"ParentId":"001dL00000oMhEPQA0","Name":"Edge Communications Opportunities.pdf","Body":"BLOB(1369 bytes)","Id":"00PdL000003VRWrUAO"}
  @api invoke() {
    generatePDF({ accId: this.recordId })
      .then((result) => {
        console.log(JSON.stringify(result));
        if (result.hasOwnProperty("ParentId")) {
          let event = new ShowToastEvent({
            title: "Success",
            message: "PDF Generated and Attached Successfully!",
            variant: "success"
          });
          this.dispatchEvent(event);
        } else {
          let event = new ShowToastEvent({
            title: "Error",
            message: "PDF Generation Failed!",
            variant: "error"
          });
          this.dispatchEvent(event);
        }
      })
      .catch((error) => {
        console.log(error);
      });
  }
}
