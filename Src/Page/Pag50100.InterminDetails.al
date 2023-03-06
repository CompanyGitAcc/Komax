page 50100 "Intermin Details"
{
    Caption = 'Intermin Details';
    PageType = List;
    SourceTable = "Intermin Details";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Ledger Entry Quantity"; Rec."Item Ledger Entry Quantity")
                {
                    ApplicationArea = All;
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                    ApplicationArea = All;
                }
                field("G/L Amount"; Rec."G/L Amount")
                {
                    ApplicationArea = All;
                }
                field("Posting Filter"; Rec."Posting Filter")
                {
                    ApplicationArea = All;
                }
                field("GLAcc No. Filter"; Rec."GLAcc No. Filter")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Intermin Details")
            {
                Caption = 'Intermin Details';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                RunObject = report "Intermin Details";

                // trigger OnAction()
                // begin

                // end;

            }
        }
    }
}
