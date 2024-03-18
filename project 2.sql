/*Total Goals Scored by Each Team in a Season:*/
SELECT gameID, season, SUM(homeGoals+awayGoals) AS total_goals
FROM games
GROUP BY gameID, season;

/*Average Expected Goals Per Team*/
SELECT teamID, CAST(AVG(xGoals) AS DECIMAL (5,2)) AS avg_xGoals
FROM teamstats
GROUP BY teamID
ORDER BY avg_xGoals DESC;

/*Average Shots On Target Per Game/Team */
SELECT gameID, teamID, AVG(shotsOnTarget) AS avg_shots_on_target
FROM teamstats
GROUP BY gameID,teamID;

/*Top Scorers in a Season*/
SELECT t.teamID, p.name, MAX(t.goals) AS max_goals
FROM teamstats t
JOIN appearances a on t.gameID=a.gameID
JOIN players p on a.playerID=p.playerID
GROUP BY t.teamID, p.name
ORDER BY max_goals DESC LIMIT 5shots;

/*Assist Leaders*/
SELECT A.playerID, P.NAME, sum(A.assists) as TotalAssists
FROM project.appearances A
JOIN players P ON A.playerID=P.playerID
group by playerID, P.NAME
order by TotalAssists DESC LIMIT 5;

/*Team with Most Yellow and Red Cards*/
SELECT teamID, SUM(yellowCards) AS TotalYellowCards, SUM(redCards) AS TotalRedCards
FROM teamstats
GROUP BY  teamID
ORDER BY TotalYellowCards, TotalRedCards DESC;

/*Team with Most Fouls*/
SELECT teamID, Sum(fouls) as TotalFouls
FROM teamstats
Group by teamID
Order by TotalFouls Desc;

/*Matches Won, Lost, or Drawn by Each Team*/
Select teamID,
sum(case when result ='w' then 1 else 0 end ) as 'wins',
sum(case when result ='l' then 1 else 0 end ) as 'losses',
sum(case when result ='d' then 1 else 0 end ) as 'draws'
from teamstats
group by teamID;

/*Comparison of Shot Result*/
SELECT shooterID,  
sum(case when shotResult='BlockedShot' then 1 else 0 end) as Blocked,
sum(case when shotResult='MissedShot' then 1 else 0 end) as Missed,
sum(case when shotResult='SavedShot' then 1 else 0 end) as Saved
FROM shots
group by shooterID, shotResult;

/*Effectiveness of Set-Peieces*/
SELECT teamID,
    COUNT(*) AS total_corners,
    SUM(goals) AS goals_from_corners,
    ROUND(SUM(goals) / NULLIF(COUNT(*), 0), 2) AS goals_per_corner
FROM
    teamstats
GROUP BY
    teamID;
  
  /*Performance of Players*/
  SELECT
    position,
    playerID,
    COUNT(*) AS total_games,
    SUM(goals) AS total_goals,
    SUM(assists) AS total_assists,
    ROUND(SUM(goals) / NULLIF(COUNT(*), 0), 2) AS goals_per_game,
    ROUND(SUM(assists) / NULLIF(COUNT(*), 0), 2) AS assists_per_game,
    ROUND(SUM(goals) / NULLIF(SUM(assists), 0), 2) AS goals_to_assists_ratio
FROM
    appearances
GROUP BY
    position,
    playerID
   ORDER BY total_goals DESC;
   
   /*Percentage of Matches Won*/
   SELECT S.teamID, T.NAME,
   SUM(CASE WHEN S.RESULT = 'W' THEN 1 ELSE 0 END )/COUNT(*)*100 AS WIN_PERCENT
   FROM teamstats S
   JOIN teams T ON S.teamID=T.teamID
GROUP BY S.teamID, T.NAME
ORDER BY WIN_PERCENT DESC;

/*Matches Won at Home vs. Away*/
SELECT S.teamID, T.NAME,
COUNT(CASE WHEN location='H' AND RESULT='W' THEN 1 ELSE 0 END )AS HOME_WINS,
COUNT(CASE WHEN location='A' AND RESULT='W' THEN 1 ELSE 0 END) AS AWAY_WINS
FROM teamstats S
JOIN teams T ON S.teamID=T.teamID
GROUP BY S.teamID,T.NAME;

/*TOTAL NO. OF MATCHES PLAYED BY EACH TEAM*/
SELECT teamID, 
       COUNT(CASE WHEN LOCATION = 'h' THEN 1 END) + COUNT(CASE WHEN LOCATION = 'a' THEN 1 END) AS total_matches
FROM teamstats
GROUP BY teamid;

/*AVERAGE GOALS SCORED HOME VS. AWAY*/
select LOCATION, AVG(GOALS) AS AvgGoals
FROM teamstats
GROUP BY LOCATION;


/*Set-Peice Display of Each Player*/
select s.shooterID, p.name, s.situation,count(*) as COUNT_OF_SETPIECE
from shots s
join players p on s.shooterID=p.playerID
group by  s.shooterID, situation,p.name;

/*Average Shots On Target Using Subquery*/
SELECT teamID, AVG(total_shots_on_target) AS avg_shots_on_target
FROM (
    SELECT teamID,
           SUM(CASE WHEN LOCATION = 'H' THEN shotsOnTarget ELSE 0 END) AS total_home_shots,
           SUM(CASE WHEN LOCATION = 'A' THEN shotsOnTarget ELSE 0 END) AS total_away_shots,
           COUNT(CASE WHEN LOCATION IN ('H', 'A') THEN GAMEID END) AS total_matches,
           SUM(shotsOnTarget) AS total_shots_on_target
    FROM teamstats
    GROUP BY teamID
) AS J
GROUP BY teamID
ORDER BY avg_shots_on_target DESC;

