pageextension 59175 "TP Item Invoicing FactBox" extends "Item Invoicing FactBox"
{
    layout
    {
        addlast(content)
        {
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = all;
            }
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = all;
            }
            field("Qty. on Prod. Order"; Rec."Qty. on Prod. Order")
            {
                ApplicationArea = all;
            }
            field("Qty. on Component Lines"; Rec."Qty. on Component Lines")
            {
                ApplicationArea = all;
            }
        }
    }



}
