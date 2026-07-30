### Basic Backend APIs:

1. User APIs(Done)
	1. Create User -> done
	2. Get User by identifier -> done
	3. Get List of all Users -> done
	4. Update user by identifier -> done
	5. User soft del -> Done
	6. user hard del -> Done
2. Role APIs(Done)
	1. Create Role -> Done
	2. Get List of all Roles -> Done
	3. Update role by ID -> Done
	4. Del role -> Done

3. Sign up APIs
	1. Creating new Player
	2. phone verification
	3. Email verification
4. Login APIs(security, cookie management, session)
5. Authentication(APIs hierarchical restrictions)
6. Change Password APIs

7. Questions APIs(phase 1)
	1. Create new question
	2. Get question by ID
	3. Update question by ID
8. Game APIs(phase 1)
	1. Create new Game
	2. Get Game by ID
	3. Get List of all games/by user/by type(Test,Quiz,Vote)
	4. Update Game by Id
	5. Game soft del
	6. Game hard del
9. Comment APIs:(phase 1)
	1. Create new Comment
	2. Get Comment by ID
	3. Get List of all Comments
	4. Update Comment by ID
	5. Comment soft del
	6. Comment hard del
	
10. Badge APIs
	1. Create Badge
	2. Get List of Badges
	3. Update a badge
	4. remove the badge
	
11. Ranking APIs

12. handle the migration.(phase 1) -> Done*

### Complex APIs:

1. get all questions of a game (game ID)
2. get all games participated by a player (player ID)
3. get the results of a player in a specific game (player ID, game ID)
4. get all the players participated in a game (game ID)
5. ...

### Extra content:
1. Email service
2. SMS service

pip install alembic -i https://mirror-pypi.runflare.com/simple/