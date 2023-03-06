pageextension 59146 "TP Released Production Orders" extends "Released Production Orders"
{
    layout
    {
        modify("Location Code")
        {
            Visible = true;
        }
    }

    actions
    {
        addlast("F&unctions")
        {
            action("Production Shortage")
            {
                Caption = 'Production Shortage';
                ApplicationArea = all;
                Image = Text;
                RunObject = Page "Production Shortage";
            }
            action("Refresh Qty. Per")
            {
                Caption = 'Refresh Qty. Per';
                ApplicationArea = all;
                Image = Refresh;
                trigger OnAction()
                var
                    ProdOrderComponent: Record "Prod. Order Component";
                    window: Dialog;
                begin
                    Window.open('Prod. Order No. #1################## \' +
                    'Line No.#2##################');
                    ProdOrderComponent.Reset();
                    ProdOrderComponent.SetRange("Qty. Picked", 0);
                    ProdOrderComponent.SetFilter("Unit of Measure Code", '%1|%2|%3', 'CM2', 'M2', 'M');
                    if ProdOrderComponent.FindFirst() then
                        repeat
                            window.Update(1, ProdOrderComponent."Prod. Order No.");
                            window.Update(2, ProdOrderComponent."Line No.");
                            ProdOrderComponent.Validate("Quantity per");
                            ProdOrderComponent.Modify();
                        until ProdOrderComponent.Next() = 0;
                    window.Close();
                end;
            }

        }
    }
    var
        Text002: Label 'Will you confirm?';
}
