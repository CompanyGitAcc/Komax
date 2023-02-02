// xmlport 50027 "Import Purchase Line Komax"
// {
//     Caption = 'Import Purchase Line Komax';
//     Direction = Import;
//     FieldDelimiter = '"';
//     FieldSeparator = ',';
//     Format = VariableText;
//     FormatEvaluate = Legacy;
//     TextEncoding = WINDOWS;

//     schema
//     {
//         textelement(Root)
//         {
//             tableelement("Purchase Line"; "Purchase Line")
//             {
//                 XmlName = 'PurchaseLine';
//                 AutoSave = false;
//                 textelement("No.")
//                 {
//                     MinOccurs = Zero;
//                 }
//                 textelement(Quantity)
//                 {
//                     MinOccurs = Zero;
//                 }

//                 trigger OnPreXmlItem()
//                 begin
//                     IF CurrXmlport.IMPORT THEN BEGIN
//                         REPEAT
//                             CurrFile.READ(cha);
//                         UNTIL cha = 10;
//                     END;

//                     LineNo := 10000;
//                 end;

//                 trigger OnBeforeInsertRecord()
//                 begin
//                     ItemNo := '';
//                     ItemQuantity := 0;

//                     PurchaseLine.RESET;
//                     PurchaseLine.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
//                     PurchaseLine.SETRANGE("Document Type", GDocType);
//                     PurchaseLine.SETRANGE("Document No.", GDocNo);
//                     IF PurchaseLine.FIND('+') THEN
//                         LineNo := PurchaseLine."Line No.";

//                     LineNo += 10000;
//                     PurchaseLine."Line No." := LineNo;
//                 end;

//                 trigger OnAfterInsertRecord()
//                 begin
//                     ItemNo := "No.";
//                     ItemQuantity := PurchaseLine.Quantity;

//                     PurchaseLine.VALIDATE("Document Type", GDocType);
//                     PurchaseLine.VALIDATE("Document No.", GDocNo);
//                     PurchaseLine.VALIDATE(Type, PurchaseLine.Type::Item);
//                     PurchaseLine.VALIDATE("No.", ItemNo);
//                     PurchaseLine.VALIDATE(Quantity, ItemQuantity);
//                     PurchaseLine.INSERT(TRUE);
//                 end;


//             }
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     procedure SetDocNo(_DocNo: Code[20]; _DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order")
//     begin
//         GDocNo := _DocNo;
//         GDocType := _DocType;
//     end;

//     var
//         ItemNo: Code[20];
//         ItemQuantity: Decimal;
//         UnitPrice: Decimal;
//         SalesLine: Record "Sales Line";
//         LineNo: Integer;
//         cha: Char;
//         GDocNo: Code[20];
//         GDocType: Option;
//         PurchaseLine: Record "Purchase Line";

// }
