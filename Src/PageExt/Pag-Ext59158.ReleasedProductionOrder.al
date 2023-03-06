pageextension 59158 "MP Released Production Order" extends "Released Production Order"
{
    layout
    {
        addlast(General)
        {
            field(SystemCreatedBy; TPUtilities.GetCreatedByName(Rec.SystemCreatedBy))
            {
                Caption = 'Created By';
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                Caption = 'Created At';
            }
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

        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        ManufacturingSetup.Reset();
        ManufacturingSetup.get();
        if ManufacturingSetup."Production Location" <> '' then
            Rec."Location Code" := ManufacturingSetup."Production Location";
    end;

    var
        TPUtilities: Codeunit "TP Utilities";
}
