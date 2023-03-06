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

    actions
    {
        addlast(processing)
        {
            // action("Refresh Order Type")
            // {
            //     Caption = 'Refresh Order Type';
            //     Image = Refresh;
            //     Promoted = true;
            //     PromotedCategory = Category4;
            //     PromotedIsBig = true;

            //     trigger OnAction()
            //     var
            //         SalesHeader: Record "Sales Header";
            //         SalesHeader2: Record "Sales Header";
            //         window: Dialog;
            //     begin
            //         window.Open('#1########');
            //         SalesHeader.Reset();
            //         SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
            //         if SalesHeader.FindFirst() then
            //             repeat
            //                 window.Update(1, SalesHeader."No.");
            //                 if SalesHeader2.get(SalesHeader2."Document Type"::Order, SalesHeader."Order No.") then begin
            //                     SalesHeader."Order Type" := SalesHeader2."Order Type";
            //                     SalesHeader.Modify();
            //                 end;
            //             until SalesHeader.Next() = 0;
            //         window.Close();
            //     end;
            // }
        }
    }
}
