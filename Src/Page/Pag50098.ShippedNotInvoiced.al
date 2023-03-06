page 50098 "Shipped Not Invoiced"
{
    Editable = false;
    PageType = List;
    SourceTable = "Sales Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                }
                field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
                {
                }
                field("Machine Model"; Rec."Machine Model")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Amount Excl VAT"; Rec."Amount Excl VAT")
                {
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                }
                field("Outstanding Amount"; Rec."Outstanding Amount")
                {
                }
                field("Material Shipped not Invoiced"; Rec."Material Shipped not Invoiced")
                {
                }
                field("Partial Shipped"; Rec."Partial Shipped")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                }
                field("Order Type"; Rec."Order Type")
                {
                }
                field("Order Date"; Rec."Order Date")
                {
                }
            }
        }
    }

    actions
    {

    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("Order Type", Rec."Order Type"::Warranty);
        Rec.SetFilter("Material Shipped not Invoiced", '<>0');
    end;

    var
        VAT: Decimal;
}

