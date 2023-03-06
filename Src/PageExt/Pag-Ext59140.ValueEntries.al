pageextension 59140 "TP Value Entries" extends "Value Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("Add Rate"; Rec."Add Rate")
            {
                ApplicationArea = all;
            }
            field("Vendor"; Rec."Vendor")
            {
                ApplicationArea = all;
            }
            field("Item Ledger Entry PostingDate"; Rec."Item Ledger Entry PostingDate")
            {
                ApplicationArea = all;
            }
            field("Komax Reason Code"; Rec."Komax Reason Code")
            {
                ApplicationArea = all;
            }

        }
    }

}
