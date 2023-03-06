page 50051 "Item Bin Inventory"
{
    Editable = false;
    PageType = List;
    SourceTable = "Item Bin Inventory";
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Zone Code"; Rec."Zone Code")
                {
                }
                field("Bin Code"; Rec."Bin Code")
                {
                }
                field("Unit Of Measure"; Rec."Unit Of Measure")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
            }



        }
    }

    actions
    {

    }


}


