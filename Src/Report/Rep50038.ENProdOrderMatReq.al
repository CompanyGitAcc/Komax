report 50038 "EN Prod. Order - Mat. Req."
{
    WordLayout = './Layout/ProdOrderMatReq.docx';
    Caption = 'Prod. Order - Mat. Requisition';
    DefaultLayout = Word;
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING(Status, "No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = Status, "No.", "Source Type", "Source No.";
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(ProdOrderTableCaptionFilter; TableCaption + ':' + ProdOrderFilter)
            {
            }
            column(No_ProdOrder; "No.")
            {
            }
            column(Desc_ProdOrder; Description)
            {
            }
            column(SourceNo_ProdOrder; "Source No.")
            {
                IncludeCaption = true;
            }
            column(Status_ProdOrder; Status)
            {
            }
            column(Qty_ProdOrder; Quantity)
            {
                IncludeCaption = true;
            }
            column(Filter_ProdOrder; ProdOrderFilter)
            {
            }
            column(ProdOrderMaterialRqstnCapt; ProdOrderMaterialRqstnCaptLbl)
            {
            }
            column(CurrReportPageNoCapt; CurrReportPageNoCaptLbl)
            {
            }
            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                DataItemTableView = SORTING("Trolley No.") WHERE("Flushing Method" = CONST("Pick + Backward"));
                column(ItemNo_ProdOrderComp; "Item No.")
                {
                    IncludeCaption = true;
                }
                column(Desc_ProdOrderComp; Description)
                {
                    IncludeCaption = true;
                }
                column(Qtyper_ProdOrderComp; "Quantity per")
                {
                    IncludeCaption = true;
                }
                column(UOMCode_ProdOrderComp; "Unit of Measure Code")
                {
                    IncludeCaption = true;
                }
                column(RemainingQty_ProdOrderComp; "Remaining Quantity")
                {
                    IncludeCaption = true;
                }
                column(Scrap_ProdOrderComp; "Scrap %")
                {
                    IncludeCaption = true;
                }
                column(DueDate_ProdOrderComp; Format("Due Date"))
                {
                    IncludeCaption = false;
                }
                column(LocationCode_ProdOrderComp; "Location Code")
                {
                    IncludeCaption = true;
                }
                //++Harvey
                column(ABCPart; ABCPart)
                {
                }
                column(TrolleyNo; "Trolley No.")
                {
                }
                column(FlushingMethod; "Flushing Method")
                {
                }
                column(SuggestedBin; SuggestedBin)
                {
                }
                //--Harvey
                trigger OnAfterGetRecord()
                var
                    BinContent: Record "Bin Content";
                begin
                    SuggestedBin := '';
                    BinContent.Reset();
                    BinContent.SetRange("Item No.", "Prod. Order Component"."Item No.");
                    BinContent.SetRange("Location Code", "Prod. Order Component"."Location Code");
                    BinContent.SETFILTER(Quantity, '>%1', 0);
                    if BinContent.FindFirst() then begin
                        REPEAT
                            BinContent.CalcFields(Quantity);
                            SuggestedBin := SuggestedBin + '【' + BinContent."Zone Code" + '/' + BinContent."Bin Code" + '/Qty:' + FORMAT(BinContent.Quantity) + '】  ';
                        UNTIL BinContent.NEXT = 0;
                    end;

                    with ReservationEntry do begin
                        SetCurrentKey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");

                        SetRange("Source Type", DATABASE::"Prod. Order Component");
                        SetRange("Source ID", "Production Order"."No.");
                        SetRange("Source Ref. No.", "Line No.");
                        SetRange("Source Subtype", Status);
                        SetRange("Source Batch Name", '');
                        SetRange("Source Prod. Order Line", "Prod. Order Line No.");

                        if FindSet then begin
                            RemainingQtyReserved := 0;
                            repeat
                                if ReservationEntry2.Get("Entry No.", not Positive) then
                                    if (ReservationEntry2."Source Type" = DATABASE::"Prod. Order Line") and
                                       (ReservationEntry2."Source ID" = "Prod. Order Component"."Prod. Order No.")
                                    then
                                        RemainingQtyReserved += ReservationEntry2."Quantity (Base)";
                            until Next() = 0;
                            if "Prod. Order Component"."Remaining Qty. (Base)" = RemainingQtyReserved then
                                CurrReport.Skip();
                        end;
                    end;

                    if Item.get("Item No.") then begin
                        ABCPart := Item."ABC-Part";
                        // FlushingMethod := FORMAT(Item."Flushing Method");
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Remaining Quantity", '<>0');
                end;
            }

            trigger OnPreDataItem()
            begin
                ProdOrderFilter := GetFilters;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        ProdOrderCompDueDateCapt = 'Due Date';
    }

    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        ProdOrderFilter: Text;
        RemainingQtyReserved: Decimal;
        ProdOrderMaterialRqstnCaptLbl: Label 'Prod. Order - Material Requisition';
        CurrReportPageNoCaptLbl: Label 'Page';
        Item: Record Item;
        ABCPart: Code[20];
        // FlushingMethod: Text[20];
        SuggestedBin: Text;
}


