using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Player : MonoBehaviour {

		private Animator anim;
		private CharacterController controller;

		public float speed = 600.0f;
		public float turnSpeed = 400.0f;
		private Vector3 moveDirection = Vector3.zero;
		public float gravity = 20.0f;

		List< Coordinates > list  = new List<Coordinates>();
		
		// { -5,-3}, {-5,1}, {-5, 2}, {-5, 3},
		// { -4,3}, 
		// {-3,3},
		// {-1,-3},
		// {0, -1}, {0,-2}, {0,-3},
		// {1, -1}, {1,-2}, {1,-3},
		// {2, -2}, {2,-3},
		// {3, -2},{3,-3},
		// {4, -1}, {4,-2}, {4,-3},{4,3}
		
		
		
		Vector2 CurPos = Vector2.zero;
		Vector2 tempPos = Vector2.zero;
		
		
		void Start () {
			
			list.Add ( new Coordinates(-5,-3)); list.Add ( new Vector2(-5,-1));list.Add ( new Vector2(-5,3));
			list.Add ( new Vector2(-4,3));
			list.Add ( new Vector2(-3,3));
			list.Add ( new Vector2(-1,-3));
			list.Add ( new Vector2(0,-1));list.Add ( new Vector2(0,-2));list.Add ( new Vector2(0,-3));
			list.Add ( new Vector2(1,-1));list.Add ( new Vector2(1,-2));list.Add ( new Vector2(1,-3));
			list.Add ( new Vector2(2,-2));list.Add ( new Vector2(2,-3));
			list.Add ( new Vector2(3,-2));list.Add ( new Vector2(3,-3));
			list.Add ( new Vector2(4,-1));list.Add ( new Vector2(4,-2));list.Add ( new Vector2(4,-3));list.Add ( new Vector2(4,3));


			controller = GetComponent <CharacterController>();
			anim = gameObject.GetComponentInChildren<Animator>();
			tempPos = CurPos;
		}

		void Update (){
			
			// 安方向键时， 先转向， 再判断能不能走  能的话再播放行走动画+再移动对象

			if (Input.GetKey ("w"))
			{
				tempPos.y = CurPos.y + 1;
				bool canRun = true;
				for (int i = 0; i < list.Count; i++)
				{
					if(list[i].x == tempPos.x && )
				}
				foreach (var kv in list)
				{
					if (kv.Key == tempPos.x && kv.Value == tempPos.y)
					{
						canRun = false;
						break;
					}
				}

				if (canRun)
				{
					anim.SetInteger ("AnimationPar", 1);
					
					moveDirection = transform.forward * Input.GetAxis("Vertical") * speed;
					transform.Rotate(0, 0, 0);
				}
			}  
			// else {
			// 	anim.SetInteger ("AnimationPar", 0);
			// }
			//
			// if(controller.isGrounded){
			// 	moveDirection = transform.forward * Input.GetAxis("Vertical") * speed;
			// }
			//
			//
			//
			//
			// float turn = Input.GetAxis("Horizontal");
			//
			// controller.Move(moveDirection * Time.deltaTime);
		}
		
		public class   Coordinates
		{
			public int x;
			public int y;
		}
}
