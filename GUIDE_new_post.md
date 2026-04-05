# How to Add & Publish New Posts

Welcome to the modernized content management workflow for CloudToAILearn.dev!

## 1. Using the Admin Dashboard (Recommended)

You no longer need to write Markdown files manually. The local Admin Panel makes managing content simple.

1. **Start the Admin Panel:**
   Double-click the `run_admin.bat` file in the `admin/` folder to start the Flask app.
2. **Access the Panel:**
   Open your browser and navigate to `http://127.0.0.1:5000`.
3. **Create a Post:**
   Go to the **"Posts"** tab and click **"New Post"**.
   - Input your Title (it automatically generates a URL slug).
   - Select the Tags and Category from the checkboxes.
   - You can upload images using the "Upload" button (they save directly to `static/images/posts/your-slug/` and paste Markdown into the editor).
   - Write your post using the rich Markdown editor toolbar.
4. **Publish your Changes:**
   Head to the **"Publish"** tab, verify what changed, enter a small message, and click **Commit & Push**.
   - GitHub Actions will catch this push and automatically deploy your new post to your live site!

## 2. Using the Manual Way (Hugo CLI)

If you still prefer the manual way occasionally:

1. Open your terminal in the `MYSITE` folder.
2. Run `hugo new posts/your-post-name.md`.
3. Open the newly created `content/posts/your-post-name.md` file in your editor.
4. Fill in the YAML frontmatter.
5. Push to GitHub:
   ```cmd
   git add .
   git commit -m "Add new post manually"
   git push origin main
   ```

Enjoy the fast and dynamic writing experience!
