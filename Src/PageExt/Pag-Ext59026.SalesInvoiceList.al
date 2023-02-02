pageextension 59026 "TP Sales Invoice List" extends "Sales Invoice List"
{
    layout
    {
        modify(Status)
        {
            Visible = true;
        }
        moveafter("Location Code"; Status)
        addafter("Sell-to Customer No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
                trigger OnDrillDown()
                var
                    SalesOrder: page "Sales Order";
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.SetRange("No.", rec."Order No.");
                    SalesOrder.SetTableView(SalesHeader);
                    SalesOrder.RunModal();
                    Clear(SalesOrder);
                end;
            }
        }
    }
}
