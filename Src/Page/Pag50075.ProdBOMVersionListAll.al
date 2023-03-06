page 50075 "Prod. BOM Version List All"
{
    Caption = 'Prod. BOM Version List';
    CardPageID = "Production BOM Version";
    DataCaptionFields = "Production BOM No.", "Version Code", Description;
    Editable = false;
    PageType = List;
    SourceTable = "Production BOM Version";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Version Code"; Rec."Version Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {

                    trigger OnValidate()
                    begin
                        StartingDateOnAfterValidate;
                    end;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    local procedure StartingDateOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}

