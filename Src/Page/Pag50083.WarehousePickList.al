page 50083 "Warehouse Pick List"
{
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Activity Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Source Type"; Rec."Source Type")
                {
                }
                field("Source No."; Rec."Source No.")
                {
                }
                field("Source Document"; Rec."Source Document")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Shelf No."; Rec."Shelf No.")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Qty. to Handle"; Rec."Qty. to Handle")
                {
                }
                field("Qty. Handled"; Rec."Qty. Handled")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

