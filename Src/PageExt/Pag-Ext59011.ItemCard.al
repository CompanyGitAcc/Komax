pageextension 59011 "TP Item Card" extends "Item Card"
{
    layout
    {
        addafter("Item Category Code")
        {
            field("Product Group"; Rec."Product Group")
            {
                ApplicationArea = all;
            }

        }
        addlast(Item)
        {
            field(Remark; Rec.Remark)
            {
                ApplicationArea = all;
            }
        }
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = all;
            }
            field("Description 3"; Rec."Description 3")
            {
                ApplicationArea = all;
            }
        }
        addafter(Warehouse)
        {
            group(Komax)
            {
                Caption = 'Komax Extension';
                field("ABC-Part"; Rec."ABC-Part")
                {
                    ApplicationArea = all;
                }
                field("Altern. Part #"; Rec."Altern. Part #")
                {
                    ApplicationArea = all;
                }
                field("Customs Supervision"; Rec."Customs Supervision")
                {
                    ApplicationArea = all;
                }
                field("Customs Class. No."; Rec."Customs Class. No.")
                {
                    ApplicationArea = all;
                }
                field("Trolley No."; Rec."Trolley No.")
                {
                    ApplicationArea = all;
                }
                field("Output Item"; Rec."Output Item")
                {
                    ApplicationArea = all;
                }
                field("QC Check Need"; Rec."QC Check Need")
                {
                    ApplicationArea = all;
                }
                field("Part status"; Rec."Part status")
                {
                    ApplicationArea = all;
                }
            }
        }

        addafter(ItemTracking)
        {
            group(Dimensions)
            {
                Caption = 'Dimensions';
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 3 Code"; Rec."Global Dimension 3 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 4 Code"; Rec."Global Dimension 4 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 5 Code"; Rec."Global Dimension 5 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 6 Code"; Rec."Global Dimension 6 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 7 Code"; Rec."Global Dimension 7 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 8 Code"; Rec."Global Dimension 8 Code")
                {
                    ApplicationArea = all;
                }
            }

        }

        modify("Search Description") { Visible = true; }
        modify("Tax Group Code") { Visible = false; }

    }

    actions
    { //promote Bin contents
        modify("&Bin Contents")
        {
            Promoted = true;
            PromotedCategory = Category4;
            PromotedIsBig = true;
        }
    }
}
