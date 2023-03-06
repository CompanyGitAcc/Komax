pageextension 50033 "TP Accountant Role Center" extends "Accountant Role Center"
{

    actions
    {
        //#Add - Reports, CHN Localizations #
        addafter(tasks)
        {

            group(Report)
            {
                Caption = 'Report';
                Image = Report;

                action("Earning Analysis Report")
                {
                    ApplicationArea = Basic, Suite;
                    Image = Report;
                    Caption = 'Earning Analysis Report';
                    RunObject = Page "TP Earning Analysis Report";
                }

                action("Intermin Details")
                {
                    ApplicationArea = Basic, Suite;
                    Image = Report;
                    Caption = 'Intermin Details';
                    RunObject = Page "Intermin Details";
                }
                action("CN Aged Account Receivables")
                {
                    ApplicationArea = Basic, Suite;
                    Image = Report;
                    Caption = 'CN Aged Account Receivables';
                    RunObject = report "CN Aged Accounts Receivable";
                }
                action("CN Inventory Valuation")
                {
                    ApplicationArea = Basic, Suite;
                    Image = Report;
                    Caption = 'CN Inventory Valuation';
                    RunObject = report "CN Inventory Valuation";
                }
            }
        }

        addlast("Posted Documents")
        {
            action("Posted Purchase Receipts")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Posted Purchase Receipts';
                RunObject = Page "Posted Purchase Receipts";
            }
            action("Posted Documents Check")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Posted Documents';
                Image = LedgerEntries;
                RunObject = Page "Posted Documents";
            }
        }


    }
}
