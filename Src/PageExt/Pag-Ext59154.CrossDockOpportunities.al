pageextension 59154 "TP Cross-Dock Opportunities" extends "Cross-Dock Opportunities"
{
    layout
    {
        modify("Qty. Cross-Docked (Base)")
        {
            Visible = true;
        }
    }

    actions
    {
        addafter("Refresh &Cross-Dock Opportunities")
        {
            // action("Quantity Allocation")
            // {
            //     ApplicationArea = Warehouse;
            //     Caption = 'Quantity Allocation';
            //     Image = Refresh;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;

            //     trigger OnAction()
            //     var
            //         WarehouseReceiptLine: Record "Warehouse Receipt Line";
            //     begin
            //         // WarehouseReceiptLine.QuantityAllocation(Rec."Source Name/No.", Rec."Source Line No.");
            //         // CurrPage.Update();
            //     end;
            // }
        }
    }

}
