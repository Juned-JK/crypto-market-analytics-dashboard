CREATE DATABASE crypto_pj;
use crypto_pj;

SELECT * FROM crypto_data;
describe crypto_data;

-- Market overview
select sum(market_cap) from crypto_data;
select sum(volume_24h) from crypto_data;
select avg(price) from crypto_data;

-- Top/bottom ranked coins
SELECT `rank`, `name`, symbol, price, market_cap FROM crypto_data ORDER BY `rank` ASC LIMIT 10;
SELECT `rank`, `name`, symbol, price, market_cap FROM crypto_data ORDER BY `rank` DESC LIMIT 10;

-- Top market cap coins
select `name` , market_cap from crypto_data order by market_cap Desc limit 10;
select `name` , market_cap from crypto_data order by market_cap asc limit 10;

-- Top volume coins
select `name` , volume_24h from crypto_data order by volume_24h Desc limit 10;

-- Gainers/losers
select `name` , change_24h, volume_24h  from crypto_data order by change_24h Desc limit 10;
select `name` , change_24h, volume_24h  from crypto_data order by change_24h Asc limit 10;

-- Volatility
select `name`, abs(change_1h)+abs(change_24h)+abs(change_7d) as Volatility from crypto_data order by Volatility desc limit 10; 
select `name`, abs(change_1h)+abs(change_24h)+abs(change_7d) as Volatility from crypto_data order by Volatility asc limit 10; 
select `name`, abs(change_24h) from crypto_data where abs(change_24h) > 20 order by abs(change_24h) desc limit 10;
SELECT AVG(ABS(change_1h) + ABS(change_24h) + ABS(change_7d)) AS average_volatility FROM crypto_data;

-- Liquidity checks
select `name`, volume_24h, market_cap,circulating_supply,total_supply,max_supply,`rank` from crypto_data where volume_24h > 1000000 and market_cap < 100000;
select `name`, volume_24h, `rank`, market_cap from crypto_data where `rank` > 1000 and volume_24h > 1000000 order by `rank` desc , volume_24h asc;

-- Top 10 market share
SELECT (SUM(CASE WHEN `rank` <= 10 THEN market_cap END) / SUM(market_cap)) AS top10_market_share FROM crypto_data;

-- Risk segmentation
select `name`, `rank`, (abs(change_1h) + abs(change_24h) + abs(change_7d)+ abs(change_30d)) as volatile,
case
	when (abs(change_1h) + abs(change_24h) + abs(change_7d)+ abs(change_30d)) <= 10 then 'low_risk'
    when (abs(change_1h) + abs(change_24h) + abs(change_7d)+ abs(change_30d)) <= 20 and (abs(change_1h) + abs(change_24h) + abs(change_7d)+ abs(change_30d)) > 10 then 'medium_risk'
    when (abs(change_1h) + abs(change_24h) + abs(change_7d)+ abs(change_30d)) > 20 then 'high_risk'
end as risk_analysis from crypto_data ;


-- Supply analysis
select `name`, `rank`, max_supply from crypto_data where max_supply = ' ';
select * from crypto_data;
select `name`, circulating_supply from crypto_data where circulating_supply =  (select min(circulating_supply) from crypto_data);
select `name`, circulating_supply from crypto_data where circulating_supply =  (select max(circulating_supply) from crypto_data);

-- Market cap comparison by risk
select avg(case
	when (abs(change_1h) + abs(change_24h) + abs(change_7d)+ abs(change_30d)) > 25 then market_cap 
    end) as MC_of_high_volatile_coins ,
avg(case
	when (abs(change_1h) + abs(change_24h) + abs(change_7d)+ abs(change_30d)) < 10 then market_cap 
    end) as MC_of_low_volatile_coins 
from crypto_data;

select 
count(case
	when (abs(change_1h) + abs(change_24h) + abs(change_7d)+ abs(change_30d)) <= 10 then `name`
    end) as Low_risk_total_coins,
count(case    
		when (abs(change_1h) + abs(change_24h) + abs(change_7d)+ abs(change_30d)) <= 20 and (abs(change_1h) + abs(change_24h) + abs(change_7d)+ abs(change_30d)) > 10 then `name`
		end) as medium_risk_total_coins,
count(case    
		when (abs(change_1h) + abs(change_24h) + abs(change_7d)+ abs(change_30d)) > 20 then `name`
        end) as high_risk_total_coins from crypto_data ;

    
