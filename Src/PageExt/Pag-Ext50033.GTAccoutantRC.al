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
        }


    }
}
