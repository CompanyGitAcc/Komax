pageextension 59150 "TP Planning Worksheet" extends "Planning Worksheet"
{
    layout
    {
        modify("Vendor No.")
        {
            Visible = true;
        }

        // addafter(Description)
        // {
        //     field("Customs Supervision"; Rec."Customs Supervision")
        //     {
        //         ApplicationArea = all;
        //     }
        // }
    }

    actions
    {
        addlast("F&unctions")
        {
            action("Accept")
            {
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Accept';
                Image = Confirm;

                trigger OnAction()
                var
                    RequisitionLine: Record "Requisition Line";
                begin
                    CurrPage.SetSelectionFilter(RequisitionLine);
                    if RequisitionLine.FindFirst() then
                        RequisitionLine.MODIFYALL("Accept Action Message", TRUE);
                    CurrPage.Update();
                end;
            }
            action("Cancel")
            {
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Cancel';
                Image = Cancel;

                trigger OnAction()
                var
                    RequisitionLine: Record "Requisition Line";
                begin
                    CurrPage.SetSelectionFilter(RequisitionLine);
                    if RequisitionLine.FindFirst() then
                        RequisitionLine.MODIFYALL("Accept Action Message", False);
                    CurrPage.Update();
                end;
            }
        }
    }
}
