---
expect:
  period: last_month
---

HTTP 200 OK

{"summary":"Last month: 1,840.00 EUR from 46 orders, up 12% on the month before.","data":{"period":"last_month","from":"2026-10-01","to":"2026-10-31","revenue":"1840.00 EUR","orders":46,"average_order":"40.00 EUR","items_sold":121,"change":{"revenue_pct":12,"orders_pct":8},"best_sellers_by_quantity":[{"sku":"MUG-CER-01","name":"Ceramic mug, blue glaze","qty":31,"revenue":"558.00 EUR"},{"sku":"CANDLE-LAV","name":"Lavender candle","qty":24,"revenue":"288.00 EUR"},{"sku":"BOWL-CER-02","name":"Ceramic bowl, white","qty":15,"revenue":"330.00 EUR"}]}}
