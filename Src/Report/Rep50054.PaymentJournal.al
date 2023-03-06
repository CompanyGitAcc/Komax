report 50054 "Payment Journal"
{
    RDLCLayout = './Layout/PaymentJournal.rdlc';
    Caption = 'Payment Journal';
    DefaultLayout = RDLC;
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.") WHERE("Account Type" = CONST(Vendor), "Journal Template Name" = CONST('PAYMENTS'));
            RequestFilterFields = "Journal Batch Name", "Account Type", "Account No.";

            column(Journal_Template_Name; "Journal Template Name")
            {
            }
            column(Line_No_; "Line No.")
            {
            }
            column(Account_Type; "Account Type")
            {
            }
            column(Account_No_; "Account No.")
            {
            }
            column(Account_No_2; "Account No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Document_Type; "Document Type")
            {
            }
            column(Document_No_; "Document No.")
            {
            }
            column(Description; Description)
            {
            }
            column(vendno; vendno)
            {
            }
            column(vendname; vendname)
            {
            }
            column(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
            {
            }
            column(Applies_to_Doc__No_; "Applies-to Doc. No.")
            {
            }
            column(BankAccountNo; Bank."Bank Account No.")
            {
            }
            column(BankName; Bank.Name)
            {
            }
            column(Amount; Amount)
            {
            }
            column(Amount__LCY_; "Amount (LCY)")
            {
            }
            column(Vendor_Name; "Vendor Name")
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FIELDNO("Account No.");
                CurrReport.CreateTotals(Amount, "Amount (LCY)");
            end;

            trigger OnAfterGetRecord()
            begin
                PrintOnlyOnePerPage := true;
                CALCFIELDS("Vendor Name");
                VendBankAcc.SETRANGE("Vendor No.", "Gen. Journal Line"."Account No.");
                IF VendBankAcc.FIND('-') THEN BEGIN
                    vendno := VendBankAcc."Bank Account No.";
                    vendname := VendBankAcc.Name;
                END ELSE BEGIN
                    vendno := '';
                    vendname := '';
                END;

            end;


        }
    }

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        BankName: Text[30];
        Bank: Record "Bank Account";
        VendBankAcc: Record "Vendor Bank Account";
        vendno: Code[50];
        vendname: Text[100];
        ExportToExcel: Boolean;
        TempExcelBuffer: Record "Excel Buffer";
        GenJournalLine: Record "Gen. Journal Line";
        gstrDateFilter: Text[50];
        RowNo: Integer;
        DateFilterTxt: Text[50];
        DateFilterMIN: Text[50];
        DateFilterMAX: Text[50];
        PrintOnlyOnePerPage: Boolean;
}


