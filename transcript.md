I'll format the conversation between Jonatas and Mihaela for better readability:

# Conversation between Jonatas and Mihaela

**Mihaela:** Yeah, sorry. Allow me to share a screen. Okay, so now you can see my screen, right? Oh, entire screen? Yeah, yeah, entire screen. Okay.

So what I wanted to show was this: I converted this to YAML. What is this? Oh, this is my old task. Okay, so I converted this to YAML. Why is this like this? I don't know. So this is the YAML that I see with all of these spots. And so what is this?

No, no, this is from Swagger. So I'm just saying, but this is an error, right? Oh, okay. Okay, so... Oh.

**Jonatas:** Um.

**Mihaela:** Mm-hmm. Okay, okay. So this is 200, this is okay, and here I get what it will be. And schema is "preferred name response," and so that's in the schema components "preferred named response," and so yeah, and it's gonna be here.

**Jonatas:** This...

**Mihaela:** This is how I prefer to look at it because... Yeah, yeah, any, all that's great. Array item one and... Okay, string and then here no type, no... Okay, okay, so this is just... This is how it looks, you see.

Okay, I'll try to put it in my project. I'll show you my project. So this is my project that I have, and here I take the YAML. This is your YAML, and this is the new YAML, and then I create a server out of it. That's the way that I can test whether it works or not.

So you can see here, this is the server I created with this. So this is just a demo, so you can, I don't know, look, try to get some emojis. You get emojis because this is just a demo of this Open API spec. So that's the way I'll do these—I'll generate a demo. But in the same way, I also generate the network layer as you can see here.

So yeah, let me see... Yeah, so the same way I generate the network layer, which... And that way I can... So this is what I'll be doing first. I'll be just attacking this. This is the JSON with the same file, and this is YAML, and I'll be generating the network layer and the mock server. Mock server is just to make sure that this works, that it's compiled, that the specs are okay.

And then with that—where is the Figma?—we can then go on to, I guess, the first screen would be login and setup and menu, right?

No, no, okay, but I will first do the whole REST API, just to make sure that it works, and then we are going on with the UI. So the first thing is to do all of this.

You said only mocks, so I'll just then... Yeah, so when you said only mocks, it means I will include all the schemas, but with the path, I will comment all of that are not the mocks. So everything that is mock will be here, and everything else will be commented out so that it doesn't generate. And it uses Xcode OpenAPI generator, and as you can see here, it uses the generator and then it generates the code.

The only thing you need to do is just implement the main path, and here it would be how many... the mocks. Okay, so this is it. So just we have to count the verbs. So this is just one verb for endpoint. It's always get. Okay, oh, here we have both.

Yeah, yeah, we do have, but we have, I guess, one... So this is... This is the first week is making sure all the backend works and the tests work, and then we are going to do the UI. Yeah, okay. Okay, that's something I wanted.

So then we can, I guess, tomorrow we can write a plan or something, right? Yeah, so when you said you are five hours behind me... Okay, I can now stop sharing. Where is this? "Ask to edit"? Where is this Google thingy? Is it this?

**Jonatas:** That...

**Mihaela:** It's here. Yeah, got it. This is really... Oh, it's... This is it, okay. Stop presenting. Okay, okay.

So then we can write... So when you said you're... So now at your place, it's 2:00 p.m., right? Okay, okay. So when do you wake up? When do you start working? 7:00 a.m.? Okay, so you start working around 7:00. Okay, so then... Okay, okay, 9 a.m. at your time, right? So that would be 2 p.m. my time.

Okay, okay, so I'll have something by 2 p.m. I'll probably have maybe a version already of the built backend, or at least it will be in progress. So I will have some feedback.

It looks like we only have like maybe less than 10 API endpoints, so it shouldn't be much work, probably not even the whole week, as it looks now. But I have to see if everything compiles and everything is okay because when you sent me this, I just looked at the README on the wiki, and I looked at the project, and it was empty—that's okay, I like it like that—and then I looked at the Figma, and then I looked at the APIs the last. But that's what I should be looking at first.

So yeah, I'll probably have a plan tomorrow. I'll be smarter tomorrow. I'm just getting into this.

Oh, no, no, that's... You're correct. I'm not compiling your backend. I'm actually... Yeah, I'm using the specs to see if they're correct. And the way I'm using it is I'm using Swift, which is strongly typed. And then if it makes a backend on my end, that means that the Open API specs are correct.

So, yeah, but when I import them into the app, I want to have all the networking code generated. I don't want to write it myself. I want to generate it because then I will not have errors, and I will not have debugging, and then I can generate the tests automatically. So that way, that part is handled for me, you know, by Swift compiler, and then I will have more time for UI.

So this is the way I prefer to do it. That's why I'm not compiling your backend or correcting you. I just want to make sure that the OpenAPI specs are correct the same way that Apple uses it. That's how they do it. This is a package that's actually hosted on Apple GitHub.

Yeah, so I really love to do it because then I don't have to worry about... So let's say in the specs you say you are sending me an object, and then I receive an array, then I can say, "Oh, Jonatas, this is wrong on your side." You know what I mean? Yeah. So this is just the part where I'm done with backend from the beginning. And then I can just concentrate on the UI.

Okay, let me see it. Just let me see it. So, which one are you talking about? Mocked messages, right? Okay. Mm-hmm. Okay. Ah. Okay, okay, so this is given, we cannot change it, and this is just the way it is, and we should respect it, right? Okay, and this is something... Okay, oh yeah. I understand, I understand.

Okay, okay, so this one should be treated especially because we have to do inner parsing to see which kind of object it is. I understand different... Yeah. Okay. Okay.

Ah, yeah, yeah, yeah. So that's type "ephemeral," then "goal"... Okay, okay.

Oh, oh, okay, okay, so you edit the example as it looks in the message, and then below that, you have how it should be rendered, which corresponds to Figma. Oh, that's great, okay, okay.

Okay, so ephemeral is... When you said ephemeral, it means it's streaming, it means it should be updated as it's happening, right? So the same object should be updated multiple times. Okay, but not for the others. For the others, we are actually waiting for it to finish before... All I understand. Yeah, yeah, that's exactly...

Oh. Oh. Okay, so what you're telling me, you don't want the ephemeral object drawn word by word. You want to have animation and then wait and then draw the whole thing. Okay.

Mm-hmm. Okay, yeah, yeah, yeah, because this summer I worked on a streaming thing which is similar to ephemeral, and I had to update every word and render it in HTML, and it was coming as Markdown, so it didn't look really nice. I mean, I did it because they wanted it, but when you are rendering Markdown to HTML, you don't really know when the renderer is gonna finish the chunk, and it's gonna look good, you know.

So I was against it, but they insisted, so that's how it went out. But at the moment, you would see HTML code, and then in the next split of a second, you would see a formed HTML. So I do think I prefer this route that you chose where you are showing the animation and then you render the whole thing. I do believe that users would prefer that.

Yes, yeah, the same. Yeah. But it's not rendered as HTML; it's rendered as text, so there is not a problem of, you know, using source and then at one moment forming it. So this is just work.

Mm-hmm. Yeah, yeah, but then it doesn't look that nice, you know, because when you get a part of it, you don't have the completion of the markdown. You don't get the end, you know, tag, and so it doesn't look nice.

We would then have to process it until the end tag arrives. Like, I don't know, bold and then end of bold. And then that's a lot of work if you have to parse that as well. That's what I meant, you know.

Yeah. Yeah, I would prefer if we had text, and then let's say it's great, and then you can say, "Okay, we're gonna work on this." So it's not just plain text, so it's markdown or something. Then we can work on that because the clients didn't want to use WebView, so we actually used attributed strings, and then with attributed strings, you also have to know when the chunk ends, and in the middle of the chunk, it would look messed up, you know.

And we didn't have time to refine it, but they wanted it to be like that, and in my opinion, didn't look so nice, but they're happy with it. So, yeah, I just wanted, because of that experience, I wanted to tell you that.

Yeah, I understand. So the reason why I'm doing the generating of network client, that will be much easier, even though this is a special case, which is okay. I don't want to have problems with getting it from the network anyway. So I just want to make sure that the networking part works, I don't have to worry about it, and then I can focus on this part.

And when it comes to UI, I want to start with the first row and the other screens. I mean, there are not so many screens; there are several categories, but there's just like that animation is expanded, right? In Figma. And that's nice that it's expanded, yeah. It's nice that it's expanded, that each step of animation is shown.

**Jonatas:** Yes, yes.

**Mihaela:** Oh, yeah. Okay, okay, okay, this is too much for me to grasp at the moment. I'm now looking at the backend, and I'm looking at the main screens. Yeah, and I have to concentrate on just how I'm gonna catch—that's the most important thing—so just the backend to work and then how I'm gonna catch these and be able to manipulate them. That's the first task I'm working on.

And yeah, so SwiftUI for sure, but there's one thing: when we have that streaming message, then we have many differences, and I may need to go to UIKit for that. I'll have to test it. I'm not sure; maybe SwiftUI will work great, but diffable data sources in collection views, which is UIKit, may be better. I'll probably have to test it for, I don't know, three or four hours, not more than that, just to see.

If there's a lot of frequency, then it could be impacted, but maybe for MVP, it's not essential. Maybe it can be not behaving amazingly well because if UIKit would take more time, maybe that can be then left out, you know what I mean? To be optional. Like, let's say you want to go to production, and then in that case, you would want to optimize just that streaming part, and then maybe it should be remade in UIKit. That's a possibility that's always there with SwiftUI, you know, when you have many, many differences. UIKit...

Yeah. Yeah, because we, when I did this this summer, we opted for UIKit there because it was just streaming all the time. And then the streaming part and rendering in Markdown, it was so much better in UIKit. And the rest of the app was SwiftUI. So that's just from my experience from the summer, you know.

So maybe now SwiftUI is better, or maybe the streaming is not so frequent as it was with this app, you know. So that's just one thing I encountered. And then we decided to just do UIKit, and guys in Android also moved from Jetpack Compose to the older stuff. So that's how we kind of handled it this summer. That's a possible problem, but maybe not. But I'm just having it as an issue now.

**Jonatas:** Yes.

**Jonatas:** Yes, yes, yes.

**Mihaela:** Yeah, for sure. Yeah, we can do that. And maybe tomorrow I'll be still starting with the backend, but the day after tomorrow, I'll have it running. So I'll have even better information for the rest of the week, you know. But we should probably meet every day.

**Jonatas:** E aí...

**Mihaela:** E aí, dictate the pace, and if you're not happy, you can say, "Yeah, I'm not paying anymore," you know. So I kind of think that's fair because you don't know me, so I kind of feel that's most comfortable, and we should meet every day. Yeah, yeah, yeah.

**Jonatas:** Daily and...

**Mihaela:** Daily at the same time is great because then we get a habit of it. And then if we need to, of course, we can meet later. But let's just put it 9 a.m. your time every day, and we can see what's done.

Yeah. Yeah, yeah, yeah. I want to do this first, this backend stuff, because then I don't need to worry about it other than this special case, which I now know is a special case, so that's great. I don't want to have any surprises when it comes to backend, so then I can focus on UI rendering and looking whether this will work with SwiftUI.

Because I'm not 100% sure it will, I still don't trust SwiftUI with really frequent UI updates, but we'll see. I'm very seasoned with UIKit, so that shouldn't be a problem, but I'm just saying, maybe I'll need to work on the same screen twice, you know, but yeah, that...

Yeah, I know. Okay, it was nice talking to you. Feel free to send me NDA anytime, and we'll talk tomorrow morning, right? And happy Easter if you celebrate.

Yeah, thank you. See you tomorrow.

**Jonatas:** Bye-bye.