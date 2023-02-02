page 50082 "Shipment List"
{
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Shipment Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Source Document"; Rec."Source Document")
                {
                }
                field("Source No."; Rec."Source No.")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Bin Code"; Rec."Bin Code")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Qty. to Ship"; Rec."Qty. to Ship")
                {
                }
                field("Qty. Picked"; Rec."Qty. Picked")
                {
                }
                field("Qty. Shipped"; Rec."Qty. Shipped")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(group1)
            {
                action("Run The Shipment")
                {
                    Caption = 'Run The Shipment';
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Lrcd_WarehouseShipment: Record "Warehouse Shipment Header";
                    begin
                        Lrcd_WarehouseShipment.RESET;
                        IF Lrcd_WarehouseShipment.GET(Rec."No.") THEN
                            ;
                        PAGE.RUN(PAGE::"Warehouse Shipment", Lrcd_WarehouseShipment);
                    end;
                }
            }
        }
    }
}

