pageextension 59136 "TP Stockkeeping Unit Card" extends "Stockkeeping Unit Card"
{
    layout
    {
        addlast(General)
        {
            field("Qty. on Sales Order (Total)"; Rec."Qty. on Sales Order (Total)")
            {
                ApplicationArea = all;
            }
            field("Inventory on Location"; Rec."Inventory on Location")
            {
                ApplicationArea = all;
            }
            field("Rout Link"; Rec."Rout Link")
            {
                ApplicationArea = all;
            }
            field("Gen Prod Posting Group"; Rec."Gen Prod Posting Group")
            {
                ApplicationArea = all;
            }
        }
    }

}
